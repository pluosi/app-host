require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module AppHost
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    config.time_zone = 'Beijing'
    
    config.i18n.default_locale = "zh-CN"

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    config.eager_load_paths += %W( #{config.root}/lib/parsers #{config.root}/lib #{config.root}/lib/app_host )

    config.autoload_paths += %W( #{config.root}/lib )

    config.action_mailer.default_url_options = { :host => Settings.HOST }

  end
end

module AppHost
  class << self
    def version
      "0.1.1"
    end
  end
end