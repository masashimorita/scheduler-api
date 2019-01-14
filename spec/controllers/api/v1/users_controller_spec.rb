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

  describe 'PUT /api/v1/users/:id' do
    let!(:user) { User.create!(name: "TEST", email: "test@test.com", password: "TEST") }
    let!(:path) { "/api/v1/users/#{user.id}" }
    let(:access_token) { AuthenticateUser.new(user.email, "TEST").call }
    let(:new_name) { 'New Name' }
    let(:valid_email) { 'valid@test.com' }
    let(:valid_target_hour) { 160 }
    let(:valid_check_in) { 15 }
    let(:valid_break_hour) { 2 }

    it 'update name successfully' do
      put path, params: {name: new_name}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['user']['name']).to eq new_name
    end

    it 'update email successfully' do
      put path, params: {email: valid_email}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['user']['email']).to eq valid_email
    end

    it 'update email fail due to invalid email' do
      put path, params: {email: 'invalid@test'}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 422
    end

    it 'update target_hour successfully' do
      put path, params: {target_hour: valid_target_hour}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['user']['target_hour']).to eq valid_target_hour
    end

    it 'update target_hour fail due to invalid type' do
      put path, params: {target_hour: 'invalid'}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 422
    end

    it 'update check_in_period successfully' do
      put path, params: {check_in_period: valid_check_in}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['user']['check_in_period']).to eq valid_check_in
    end

    it 'update check_in_period fail due to invalid type' do
      put path, params: {check_in_period: 'test'}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 422
    end

    it 'update break_hour successfully' do
      put path, params: {break_hour: valid_break_hour}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 200
      expect(JSON.parse(response.body)['user']['break_hour']).to eq valid_break_hour
    end

    it 'update break_hour fail due to invalid type' do
      put path, params: {break_hour: 'test'}, headers: {Authorization: "Bearer #{access_token}"}
      expect(response.status).to eq 422
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
