class Api::V1::UsersController < Api::V1::ApiController
  skip_before_action :authorize_request, only: :create

  def create
    user = User.create!(user_params)
    auth_token = AuthenticateUser.new(user.email, user.password).call
    response = {message: Message.account_created, auth_token: auth_token, user: user.attributes.slice('id', 'email', 'name')}
    json_response(response, :created)
  end

  def show
    user = User.select(['id', 'name', 'email', 'target_hour', 'check_in_period', 'break_hour']).find(current_user.id)
    json_response({user: user}, :ok)
  end

  def update
    error = validate_params
    unless error.empty?
      return json_response({message: Message.invalid_parameter(error.join(','))}, :unprocessable_entity)
    end
    current_user.name = update_params[:name] if update_params[:name].present?
    current_user.email = update_params[:email] if update_params[:email].present?
    current_user.target_hour = update_params[:target_hour].to_i if update_params[:target_hour].present? && is_number?(update_params[:target_hour])
    current_user.check_in_period = update_params[:check_in_period].to_i if update_params[:check_in_period].present? && is_number?(update_params[:check_in_period])
    current_user.break_hour = update_params[:break_hour].to_i if update_params[:break_hour].present? && is_number?(update_params[:break_hour])
    current_user.save!
    json_response({user: current_user.attributes.slice('id', 'name', 'email', 'target_hour', 'check_in_period', 'break_hour')}, :ok)
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

  def update_params
    params.permit(:name, :email, :target_hour, :check_in_period, :break_hour)
  end

  def validate_params
    err = []
    update_params
    [:target_hour, :check_in_period, :break_hour].each do |param_name|
      if update_params[param_name].present?
        err << param_name unless is_number?(update_params[param_name]) && update_params[param_name].to_i > 0
      end
    end
    err
  end

  def is_number?(str)
    true if Float(str) rescue false
  end
end