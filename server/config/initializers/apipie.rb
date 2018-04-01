Apipie.configure do |config|
  config.app_name                = "Dependensee API Documentation"
  config.api_base_url            = "/api/v1"
  config.doc_base_url            = "/docs"
  config.app_info["1.0"] = "Dependensee API documentation"
  config.api_controllers_matcher = File.join(Rails.root, "app", "controllers","*.rb")
  config.api_routes = Rails.application.routes
  config.default_version = '1.0'
  config.validate = :explicitly

  Apipie.configure do |config|
    config.translate         = false
    config.default_locale = nil
  end

end
