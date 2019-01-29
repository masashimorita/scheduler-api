require "rails_helper"

RSpec.describe ResetTokenMailer, type: :mailer do
  describe "send_mail" do
    let!(:user) { create(:user, default_email: 'test@test.com', default_password: 'test') }

    it "renders the headers" do
      code = RememberToken::generate_code(13)
      token = RememberToken.new(email: user.email, user_id: user.id, code: code, expired_at: DateTime.now + 30.minutes)
      token.save!
      mail = ResetTokenMailer.send_mail(token)
      expect(mail.subject).to eq("Password Reset has requested")
      expect(mail.from).to eq(['from@example.com'])
    end
  end

end
