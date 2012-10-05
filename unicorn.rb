
worker_processes 4
timeout 300
listen 8000

deploy_to = "/srv/localguide"

current_path = "#{deploy_to}/current"
shared_path = "#{deploy_to}/shared"
shared_bundler_gems_path = "#{shared_path}/bundle"

working_directory current_path

preload_app true

# Fix for Unicorn not reloading across Symlinks
before_exec do |server|
  paths = (ENV["PATH"] || "").split(File::PATH_SEPARATOR)
  paths.unshift "#{shared_bundler_gems_path}/bin"
  ENV["PATH"] = paths.uniq.join(File::PATH_SEPARATOR)

  ENV['GEM_HOME'] = ENV['GEM_PATH'] = shared_bundler_gems_path
  ENV['BUNDLE_GEMFILE'] = "#{current_path}/Gemfile"
end

