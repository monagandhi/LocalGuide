require 'tungsten'
class ApplicationController < ActionController::Base
  protect_from_forgery

  include Tungsten::Controller::Authentication
  include Airbnb::Service::Logging::ActionController
end
