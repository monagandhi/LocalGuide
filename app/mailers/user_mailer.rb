class UserMailer < ActionMailer::Base
  helper :application
  helper :email

  default :from => "Airbnb <automated@airbnb.com>"

  # TODO: figure out how to move set_host into a Mail Observer
  def test(email_address)
    set_host

    mail(:to => email_address,
     :subject => "Email works!",
     'X-SMTPAPI' => "{\"category\": \"General: Test Email\"}" # sendgrid analytics
     )
  end

  private

  # This must be called on every method for the header and footer templates to render correctly.
  # Is there some kind of before_filter-like thing in ActionMailer?
  def set_host
    not_null_locale = @locale || I18n.full_locale
    # @host = TungstenSupport::Domains::canonical_host_for(not_null_locale.to_sym)
    @host = "www.airbnb.com"
  end

  # Adds http:// to what path_to_image() returns.
  # path_to_image() doesn't add it in mailers because @controller.request == nil
  # FIXME: This returns invalid URLs if ActionController::Base.asset_host == nil

  # This is borrowed from notifier.rb.
  def url_to_image(source)
    url = view_context.path_to_image(source)
    if url !~ %r{^[-a-z]+://}
      url = "http://#{@host}#{url}" # In the future, use muscache.
    end
    url
  end
  helper_method :url_to_image

end
