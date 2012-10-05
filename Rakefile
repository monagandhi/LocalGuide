#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

$LOAD_PATH << './lib'
load './lib/env.rb' # Must load this way to avoid warning about 'importenv'

require File.expand_path('../config/application', __FILE__)

LocalGuide::Application.load_tasks
