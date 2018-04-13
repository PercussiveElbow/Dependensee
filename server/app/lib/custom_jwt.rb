# app/lib/custom_jwt.rb
class CustomJWT
  HMAC = Rails.application.secrets.secret_key_base

  def self.encode(payload, exp = 24.hours.from_now) # encode the payload into JWT and return
    payload[:exp] = exp.to_i
    JWT.encode(payload,HMAC)
  end

  def self.decode(token) # Decode JWT to get token
    begin
      body = JWT.decode(token,HMAC)[0]
      HashWithIndifferentAccess.new body
    rescue JWT::ExpiredSignature, JWT::VerificationError,JWT::DecodeError  => _
      raise CustomException::InvalidToken, 'Invalid Authorization Token'
    end
  end

end