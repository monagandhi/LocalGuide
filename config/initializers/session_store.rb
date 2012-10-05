session_options = case Rails.env
when 'production'
  SESSION_COOKIE_KEY = '_airbed_session_id'
  {:key => SESSION_COOKIE_KEY, :domain => '.airbnb.com'}
when 'staging'
  SESSION_COOKIE_KEY = '_airbed_staging_session_id'
  {:key => SESSION_COOKIE_KEY, :domain => '.lab.airbnb.com'}
when 'development'
  SESSION_COOKIE_KEY = '_airbed_development_session_id'
  {:key => SESSION_COOKIE_KEY, :domain => '.airbnb.com'}
when 'test'
  SESSION_COOKIE_KEY = '_airbed_test_session_id'
  {:key => SESSION_COOKIE_KEY, :domain => '.airbnb.com'}
else
  SESSION_COOKIE_KEY = '_airbed_session_id'
  {:key => SESSION_COOKIE_KEY, :domain => '.airbnb.com'}
end

LocalGuide::Application.config.session_store :cookie_store, session_options
LocalGuide::Application.config.secret_token = 'd872e90e628b8b985bc38f10fb2b546b3b49f809ec756704ed44bb918e600c8b7d50e6c18ad4145360d3b624d7b6eebf818ef474b97bc0a5d8171119e72f4022'
