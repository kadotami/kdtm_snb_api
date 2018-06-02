class AuthorizedApiController < ApplicationController
  before_action :authenticate_user

  private
    def authenticate_user
      token = request.headers['Authorization']
      @current_user = Jwt::TokenDecoder.(token)
      puts @current_user
      render json: { error: 'Not Authorized' }, status: 401 unless @current_user
    end
end