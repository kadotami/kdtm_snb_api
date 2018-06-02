module Jwt::TokenDecoder
  extend self
 
  def call(token)
    current_user(token)
  end
 
  private
  def current_user(token)
    begin
      JWT.decode(token, 'test_string')#Rails.application.secrets.secret_key_base)
    rescue 
      false
    end
  end
end