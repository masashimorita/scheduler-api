# Preview all emails at http://localhost:3000/rails/mailers/reset_token_mailer
class ResetTokenMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/reset_token_mailer/send_mail
  def send_mail
    ResetTokenMailerMailer.send_mail
  end

end
