class AuthorizedApiController < ApplicationController
  before_action :authenticate_user
end