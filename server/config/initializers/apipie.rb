Apipie.configure do |config|
  config.app_name                = "Dependensee API Documentation"
  config.api_base_url            = ""
  config.doc_base_url            = "/doc"
  # where is your API defined?
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers","*.rb")
  config.api_routes = Rails.application.routes
  config.default_version = ''
end
