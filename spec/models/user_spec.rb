require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Create valid user' do
    let(:params) { {name: "TEST", email: "test@test.com", password: "test"} }

    it 'Create it with name, email and password' do
      user = User.create!(params)
      expect(user).to be_valid
    end
  end

  describe 'Change user password' do
    let(:user) { User.create!(name: "TEST", email: "test@test.com", password: "test") }

    it 'Change password & authenticate with it' do
      expect(user.change_password!('test', 'password')).not_to be nil
      expect(user.authenticate('password')).not_to be nil
    end
  end
end
