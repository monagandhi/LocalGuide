def env
  f = './config/env'
  ENV['RACK_ENV'] or (File.read(f).strip if File.file? f) or 'development'
end

ENV['RAILS_ENV'] = env
