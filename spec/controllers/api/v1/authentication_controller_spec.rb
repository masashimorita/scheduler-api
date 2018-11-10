require 'rails_helper'

RSpec.describe 'Api::V1::AuthenticationController', type: :request do
  describe 'POST /api/v1/signup' do
    let(:user) do
      User.create!(name:"TEST", email: "test@test.com", password: "test")
    end
    let(:path) { "/api/v1/auth/login"}

    it 'Login successfully' do
      post path, params: {email: user.email, password: user.password}

      body = JSON.parse(response.body)
      expect(response.status).to eq 200
    end
  end
end
