class Api::V1::AuthenticationController < Api::V1::ApiController
  skip_before_action :authorize_request, only: [:authenticate, :reset_password, :send_reset_token]

  def authenticate
    auth_token = AuthenticateUser.new(auth_params[:email], auth_params[:password]).call
    user = User.select(['id', 'email', 'name', 'target_hour']).find_by(email: auth_params[:email])
    json_response({auth_token: auth_token, user: user})
  end

  def reset_password
    reset_password_params
    json_response({message: Message.password_not_match}, :internal_server_error) if reset_password_params[:password] != reset_password_params[:password_confirm]
    token = RememberToken.find_by(code: reset_password_params[:code], email: reset_password_params[:email])
    return json_response({message: Message.not_found("Password Reset Token")}, :not_found) if token.nil?

    return json_response({message: Message.reset_token_expired}, :internal_server_error) if token.expired_at.to_datetime < DateTime.now

    user = User.find(token.user_id)
    return json_response({message: Message.not_found("User")}, :not_found) if user.nil?

    user.password = reset_password_params[:password]
    user.save!

    token.destroy

    json_response({message: Message.password_reset}, :ok)
  end

  def send_reset_token
    user = User.find_by_email(token_params[:email])
    return json_response({messag: Message.not_found("User")}, :not_found) if user.nil?

    code = RememberToken::generate_code(13)
    token = RememberToken.new(email: user.email, user_id: user.id, code: code, expired_at: DateTime.now + 30.minutes)
    token.save!
    ResetTokenMailer.send_mail(token).deliver_now

    json_response({message: Message.reset_password_has_requested, code: code}, :ok)
  end

  private
  def auth_params
    params.permit(:email, :password)
  end

  def token_params
    params.permit(:email)
  end

  def reset_password_params
    params.permit(:code, :email, :password, :password_confirm)
  end
end