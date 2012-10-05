require 'configatron'

if Rails.env.development?
  configatron.YOUR_APP_db = :development
  configatron.core_db = :development_core
elsif Rails.env.test?
  configatron.YOUR_APP_db = :test
  configatron.core_db = :test_core
elsif Rails.env.production?
  configatron.YOUR_APP_db = :production
  configatron.core_db = :production_core
end
