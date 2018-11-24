class Api::V1::UsersController < Api::V1::ApiController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = {message: Message.account_created, auth_token: auth_token, user: user.attributes.slice('id', 'email', 'name')}
    json_response(response, :created)
  end

  def show
    user = User.select(['id', 'name', 'email']).find(current_user.id)
    json_response(user, :ok)
  end

  def change_password
    password_params
    return json_response({message: Message.password_not_match}, :internal_server_error) if password_params[:password] != password_params[:password_confirm]
    if current_user.change_password!(password_params[:current_password], password_params[:password])
      json_response({message: Message.password_change}, :ok)
    else
      json_response({message: Message.invalid_credentials }, :internal_server_error)
    end
  end

  private
  def user_params
    params.permit(:name, :email, :password, :password)
  end

  def password_params
    params.permit(:current_password, :password, :password_confirm)
  end
end