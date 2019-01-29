require 'rails_helper'

RSpec.describe 'Api::V1::AuthenticationController', type: :request do
  let!(:user) { create(:user, default_email: 'test@test.com', default_password: 'test') }
  describe 'POST /api/v1/auth/login' do
    let(:path) { "/api/v1/auth/login"}

    it 'Login successfully' do
      post path, params: {email: user.email, password: user.password}

      body = JSON.parse(response.body)
      expect(response.status).to eq 200
    end
  end

  describe 'POST /api/v1/auth/forgetpassword' do
    let(:path) { "/api/v1/auth/forgetpassword" }
    let(:access_token) { AuthenticateUser.new(user.email, "test").call }

    it 'Request Password Reset successfully' do
      post path, params: {email: user.email}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['message']).to eq 'Password reset has requested successfully'
    end
  end

  describe 'POST /api/v1/auth/resetpassword' do
    let(:path) { "/api/v1/auth/resetpassword" }
    let(:access_token) { AuthenticateUser.new(user.email, "test").call }
    let(:code) { RememberToken::generate_code(13) }

    it do
      token = RememberToken.new(email: user.email, user_id: user.id, code: code, expired_at: DateTime.now + 30.minutes)
      token.save!

      post path, params: {code: code, email: user.email, password: "TEST", password_confirm: "TEST"}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['message']).to eq 'Password has reset successfully'
    end
  end
end
