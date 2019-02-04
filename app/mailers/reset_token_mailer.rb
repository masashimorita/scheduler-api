class ResetTokenMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.reset_token_mailer.send_mail.subject
  #
  def send_mail (remember_tokens)
    @user = User.find_by_id(remember_tokens.user_id)
    @app_name = ENV['APP_NAME']
    @url = ENV['CLIENT_BASE_URL'] + "?code=#{remember_tokens.code}"

    mail to: remember_tokens.email, subject: "Password Reset has requested"
  end
end
