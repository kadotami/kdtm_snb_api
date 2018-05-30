require 'jwt'
class UserTokenController < ApplicationController
  def create
    user = User.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
      token = Jwt::TokenProvider.(user_id: user.id)
      render json: {token: token}
    else
      render json: {error: 'Error description'}, status: 422
    end
  end
end