Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  Quickbooks.sandbox_mode = true
  # QB_KEY = "qyprdX8QgoHPx3g9sJWLssMvLzW6Dv"
  # QB_SECRET = "zVuEj7ld6WlOW5pyIelQRq4269x7SbWdNAdDP8S4"

  $qb_oauth_consumer = OAuth::Consumer.new("qyprdX8QgoHPx3g9sJWLssMvLzW6Dv", "zVuEj7ld6WlOW5pyIelQRq4269x7SbWdNAdDP8S4", {
    :site                 => "https://oauth.intuit.com",
    :request_token_path   => "https://oauth.intuit.com/oauth/v1/get_request_token",
    :authorize_url        => "https://appcenter.intuit.com/Connect/Begin",
    :access_token_path    => "https://oauth.intuit.com/oauth/v1/get_access_token"
  })
end
