class Api::V1::UsersController < Api::V1::ApiController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = { message: Message.account_created, auth_token: auth_token }
    json_response(response, :created)
  end

  def show
    user = User.select(['id', 'name', 'email']).find(current_user.id)
    json_response(user, :success)
  end

  private
  def user_params
    params.permit(:name, :email, :password, :password, :password_confirmation)
  end
end