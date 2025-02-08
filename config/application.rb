require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Store
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.1

    config.autoload_lib(ignore: %w[assets tasks])
    config.autoload_paths << Rails.root.join('app/services')
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true
    config.session_store :redis_store,
                         servers: [ENV.fetch('REDIS_URL', "redis://localhost:6379/0/session")],
                         key: "_cart_session",
                         expire_after: 14.days, # expirar sessão após duas semanas
                         secure: Rails.env.production?,
                         threadsafe: false
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::RedisStore
    config.active_job.queue_adapter = :sidekiq
  end
end
