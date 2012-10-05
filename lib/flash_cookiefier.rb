# FlashCookiefier basically copies the flash from session[:flash] into cookies[:flash]
#
# This is for a couple reasons:
#   1. This allows us to have flash messages on cached pages.  Javascript in the view
#      loads the cookies[:flash], inserts it into the DOM, and immediately deletes it
#      from the cookies.
#   2. This allows us to serialize the session as JSON.  The flash message stored in
#      session is an instance of FlashHash, which gets turned into a plain Hash when
#      it is serialized into JSON.  ActionDispatch::Flash would throw an error when it
#      tried to call sweep on a plain Hash.
#
# This class is middleware that:
#   1. clears out the session[:flash] in case there is a legacy session cookie with a
#      flash stored in it
#   2. executes the request
#   3. copies the session[:flash] (which is in memory at this point) into cookies[:flash]
#   4. clears out session[:flash] so it doesn't have to send that to the client's cookie
#
#  authors: @jeff, @raph, @jasonkb
require 'rack/utils'

class FlashCookiefier

  def initialize(app)
    @app = app
  end

  def call(env)
    if env['rack.session'].present? && env['rack.session']['flash'].present?
      Rails.logger.info "FlashCookiefier wiped the session flash: #{env['rack.session']['flash'].inspect}"
      env['rack.session'].delete 'flash'
    end

    status, headers, response = @app.call(env)

    begin
      # Just go ahead and send the flash cookie, since the JS will overwrite it anyway
      flash = env['rack.session']['flash']

      if flash && flash.respond_to?(:each) && !flash.empty?
        Rack::Utils.set_cookie_header!(headers, "flash", {:value => flash.clone.to_json, :path => "/"})
      end

      # delete the flash from the session now that we've copied it to the flash-cookie
      if env['rack.session'].present? && env['rack.session']['flash'].present?
        env['rack.session'].delete 'flash'
      end
    rescue Exception => e
      # Swallow for now, it's important that the site keeps working.
      # Need to find a way to raise this to Hoptoad
    end

    [status, headers, response]
  end

end