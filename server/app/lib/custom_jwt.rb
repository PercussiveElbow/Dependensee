# app/lib/json_web_token.rb

class CustomJWT
  HMAC = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload,HMAC)
  end

  def self.decode(token)
    begin
      body = JWT.decode(token,HMAC)[0]
      HashWithIndifferentAccess.new body
    rescue JWT::ExpiredSignature, JWT::VerificationError,JWT::DecodeError  => e
      raise CustomException::InvalidToken, 'Invalid Authorization Token'
    end
  end

end