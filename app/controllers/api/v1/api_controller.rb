class Api::V1::ApiController < ApplicationController
  include Response
  include ExceptionHandler
  include CustomValidationHelper

  attr_reader :current_user
  before_action :set_headers
  before_action :authorize_request

  private
  def authorize_request
    @current_user = AuthorizeApiRequest.new(request.headers).call[:user]
  end
  def set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, PUT, DELETE, GET, OPTIONS'
    headers['Access-Control-Request-Method'] = '*'
    headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, Accept, Authorization'
  end
end