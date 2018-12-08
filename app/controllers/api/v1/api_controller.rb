class Api::V1::ApiController < ApplicationController
  include Response
  include ExceptionHandler
  include CustomValidationHelper

  attr_reader :current_user
  before_action :authorize_request

  private
  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end
end