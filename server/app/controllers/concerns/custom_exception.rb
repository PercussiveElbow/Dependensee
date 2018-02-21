# app/controllers/concerns/exception_handler.rb
module CustomException
  extend ActiveSupport::Concern

  class AuthenticationError < StandardError; end
  class MissingToken <StandardError; end
  class InvalidToken <StandardError; end
  # class ExpiredSignature <StandardError; end
  class EmptyDependencyException < StandardError; end
  class NotFound < StandardError; end
  class ValidationError < StandardError; end


  included do
    rescue_from ActiveRecord::RecordInvalid, with: :unprocessable
    rescue_from CustomException::AuthenticationError, with: :no_auth
    rescue_from CustomException::MissingToken, with: :no_auth
    rescue_from CustomException::InvalidToken, with: :no_auth
    rescue_from CustomException::NotFound, with: :not_found
    rescue_from CustomException::ValidationError, with: :unprocessable

    rescue_from ActiveRecord::RecordNotFound do |e|
      json_response({ message: e.message }, :not_found)
    end
  end

  # 4xx errors
  def unprocessable(e)
    json_response({ message: e.message }, :unprocessable_entity)
  end

  def no_auth(e)
    json_response({ message: e.message }, :unauthorized)
  end

  def expired_sig(e)
    json_response({ message: e.message }, :expired_sig)
  end

  def not_found(e)
    json_response({ message: e.message }, :not_found)
  end

end
