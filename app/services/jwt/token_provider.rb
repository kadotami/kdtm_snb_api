module Jwt::TokenProvider
  extend self
 
  def call(payload)
    issue_token(payload)
  end
 
  private
  def issue_token(payload)
    JWT.encode(payload, 'test_string')#Rails.application.secrets.secret_key_base)
  end
end