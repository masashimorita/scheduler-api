require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  describe 'POST /api/v1/signup' do
    let(:user_params) do
      {
          name: "Test",
          email: "test@test.com",
          password: "test",
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

  describe 'POST /api/v1/users/changepassword' do
    let(:path) { "/api/v1/users/changepassword" }
    let(:user) { User.create!(name: "TEST", email: "test@test.com", password: "TEST") }
    let(:access_token) { AuthenticateUser.new(user.email, "TEST").call }

    it 'Change password successfully' do
      post path, params: {current_password: "TEST", password: "password", password_confirm: "password"}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['message']).to eq 'Password has changed successfully'
    end

    it 'Change password fail wiht invalid password' do
      post path, params: {current_password: "invalid", password: "password", password_confirm: "password"}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 500
      expect(JSON.parse(response.body)['message']).to eq 'Invalid credentials'
    end

    it 'Change password fail with password not match' do
      post path, params: {current_password: "TEST", password: "password1", password_confirm: "password2"}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 500
      expect(JSON.parse(response.body)['message']).to eq 'Invalid Password was given'
    end
  end

  describe 'GET /api/v1/users/me' do
    let(:path) { "/api/v1/users/me" }
    let(:user) { User.create!(name: "TEST", email: "test@test.com", password: "TEST") }
    let(:access_token) { AuthenticateUser.new(user.email, "TEST").call }

    it 'Get user info' do
      get path, headers: {Authorization: "Bearer #{access_token}"}
      body = JSON.parse(response.body)
      expect(response.status).to eq 200
      expect(body['user']['email']).to eq user.email
      expect(body['user']['name']).to eq user.name
    end
  end
end
