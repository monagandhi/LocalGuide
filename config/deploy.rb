def system!(*args)
  system(*args)
  $?.success? or abort "ERR: #{args.join(' ')}  ~>  #{$?}"
end
set :application, "LocalGuide"
set :repository,  "git@github.com:airbnb/LocalGuide.git"
set :scm,         :git

app_host = 'localguide.aws.airbnb.com'
role :web, app_host
role :app, app_host
role :db,  app_host, :primary => true

app_root = '/srv/LocalGuide'
set :deploy_to, "#{app_root}"
set :user,      'ubuntu'
set :rake,      'bundle exec rake'

# Make git talk to GitHub using your own SSH key instead of the app host's key.
ssh_options[:forward_agent] = true
ssh_shim = 'ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no "$@"'
default_environment['GIT_SSH'] = '/tmp/ssh_shim'

after 'deploy:update_code', 'deploy:rack_env'
after 'deploy:update_code', 'deploy:send_db'
after 'deploy:update_code', 'deploy:symlink_db'
after 'deploy:update_code', 'deploy:git_submodule_update'
after 'deploy:update_code', 'deploy:setup'
after 'deploy:update_code', 'deploy:symlink_release_path'
before 'deploy:cold',       'deploy:dirs'
before 'deploy:cold',       'deploy:ssh_shim'
before 'deploy',            'deploy:dirs'
before 'deploy',            'deploy:ssh_shim'
before 'deploy:start',      'deploy:restart'

namespace :deploy do
  task :ssh_shim do
    run "echo '#{ssh_shim}' > /tmp/ssh_shim ; chmod ugo+rx /tmp/ssh_shim"
  end
  task :start do ; end
  task :stop do ; end
  task :finalize_update do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "sudo sv term /etc/service/*"
  end

  # From http://matt.west.co.tt/ruby/capistrano-without-a-database/
  desc "Override deploy:cold to NOT run migrations - there's no database"
  task :cold do
    update
    start
  end

  task :setup, :roles => :app do
    run "cd #{release_path} && ./script/run setup"
  end

  task :dirs do
    run "mkdir -p #{app_root}/shared/config/"
  end

  task :rack_env do
    run "echo production > #{release_path}/config/env"
  end

  def symlink_config(filename)
    run "ln -nfs #{deploy_to}/shared/config/#{filename} #{release_path}/config/#{filename}"
  end

  def send_config(host, filename)
    system! 'rsync', '-v', "./config/#{filename}",
            "#{user}@#{host}:#{deploy_to}/shared/config/#{filename}"
  end

  desc 'Send the local database.yml file to the target machine'
  task :send_db, :roles => :app do
    send_config(app_host, 'database.yml')
  end

  desc 'Symlinks the database.yml file in the release path'
  task :symlink_db, :roles => :app do
    symlink_config 'database.yml'
  end

  desc 'Symlinks the database.yml file in the release path'
  task :git_submodule_update, :roles => :app do
    run "cd #{release_path} && git submodule update --init --recursive"
  end

  desc 'Symlinks the active abb-ws app to the current release'
  task :symlink_release_path, :roles => :app do
    run "ln -nfs #{release_path} #{app_root}/current"
  end

  desc 'Run migrations with the statically configured RAILS_ENV'
  task :migrate do
    run "cd #{release_path} && rake db:migrate"
  end

  namespace :assets do
    task :precompile do
      run "cd #{release_path} && rake assets:precompile"
    end
  end
end

# require './config/boot'
# require 'airbrake/capistrano'
