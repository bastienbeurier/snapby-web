StreetShout::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  config.eager_load = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = true

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # See everything in the log (default is :info)
  config.log_level = :debug

  # Expands the lines which load the assets
  config.assets.debug = true

  # Mailer
  config.action_mailer.default_url_options = { :host => 'dev-street-shout.herokuapp.com' }
  ActionMailer::Base.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.raise_delivery_errors = true
  ActionMailer::Base.smtp_settings = {
      :address        => 'smtp.gmail.com',
      :domain         => 'http://www.street-shout.com',
      :port           => 587,
      :user_name      => 'info@street-shout.com',
      :password       => ENV['INFO_MAIL_PASS'],
      :authentication => :plain
  }
  
end
