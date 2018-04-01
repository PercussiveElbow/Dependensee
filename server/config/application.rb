require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
require "action_cable/engine"
# require "sprockets/railtie"
require "rails/test_unit/railtie"
require_relative '../app/lib/gem/gem_db'
require_relative '../app/lib/pom/pom_db'
require_relative '../app/lib/exploit/exploit_db'
require_relative '../app/lib/exploit/exploit_db_mappings'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Untitled1
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
    
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins '*'
        resource '*', :headers => :any, :methods => [:get, :post, :options, :delete,:put]
      end
    end

    SecureHeaders::Configuration.default

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
      g.orm :active_record, foreign_key_type: :uuid
    end


    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Only loads a smaller set of middleware suitable for API only apps.
    # Middleware like session, flash, cookies can be added back manually.
    # Skip views, helpers and assets when generating a new resource.
    config.api_only = true

    if defined?(Rails::Server)
      config.after_initialize do
        ran_int = 'development'
        Logger.new(STDOUT).info '======DOWNLOADING SOURCES======'
        # Clone the RubyCVE Git Repo
        $ruby_db = GemDB::new(ran_int)
        # Clone Maven/Pip CVE Git Repo
        $maven_pip_db = MavenAndPipDB::new(ran_int)
        # Clone exploit DB
        $exploit_db = ExploitDB::new(ran_int)
        # Clone exploit DB mappings
        ExploitDbMappings::new(ran_int)
        Logger.new(STDOUT).info '======DONE DOWNLOADING     ======'
      end
    end

  end

end