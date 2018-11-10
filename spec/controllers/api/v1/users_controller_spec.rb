require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  describe 'POST /api/v1/signup' do
    let(:user_params) do
      {
          name: "Test",
          email: "test@test.com",
          password: "test",
          password_confirm: "test"
      }
    end
    let(:request) { post "/api/v1/signup", params: user_params }

    it 'Sign up user successfully' do
      request

      body = JSON.parse(response.body)
      expect(body['message']).to eq "Account created successfully"
      expect(response.status).to eq 201
    end

    it 'Sign up user fail' do
      post "/api/v1/signup", params: {name: "test", email: "test@test.com"}
      expect(response.status).to eq 422
    end

    it 'Increase user record count by 1' do
      expect{ request }.to change(User, :count).by(1)
    end
  end
end
