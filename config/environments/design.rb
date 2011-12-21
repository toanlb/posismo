Twopm::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The staging environment is meant to check bugs.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Specifies the header that your server uses for sending files
  config.action_dispatch.x_sendfile_header = "X-Sendfile"

  # For nginx:
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect'

  # If you have no front-end server that supports something like X-Sendfile,
  # just comment this out and Rails will serve the files

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Use a different logger for distributed setups
  # config.logger = SyslogLogger.new
  
  # Use log rotation
  # config.logger = Logger.new("#{Rails.root}/log/#{Rails.env}.log", shift_age='daily')

  # Enable delivery errors, bad email addresses will be raised
  config.action_mailer.raise_delivery_errors = true

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify
  
  # Action Mailer method  
  config.action_mailer.delivery_method = :sendmail
  
  # Action Mailer Host
  config.action_mailer.default_url_options = {
    host: "host",
    port: "3003"
  }
  
  BACKEND_HOST = "host"
end
