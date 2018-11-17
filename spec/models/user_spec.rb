require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Model' do
    it 'is valid with factory creation' do
      expect(build(:user)).to be_valid
    end

    describe 'association' do
      it 'shoud have many record' do
        is_expected.to have_many(:remember_tokens)
      end

      it 'should have many records' do
        is_expected.to have_many(:records)
      end

      it 'should have many monthly_reports' do
        is_expected.to have_many(:monthly_reports)
      end
    end

    describe 'ActiveModel Validation' do
      it { is_expected.to validate_presence_of :name }
      it { is_expected.to validate_presence_of :email }
      it { is_expected.to validate_presence_of :password }
      it { is_expected.to validate_confirmation_of :password}
      it { is_expected.to validate_length_of(:name).is_at_most(50) }
      it { is_expected.to validate_length_of(:email).is_at_most(255) }
      it { is_expected.to_not allow_value('example@example').for :email }
    end

    describe 'class methods' do
      let!(:user) { create(:user, default_password: 'Test') }
      it { expect(user).to respond_to(:change_password!) }

      it 'should change password' do
        expect(user.change_password!('Test', 'New Password')).not_to be nil
        expect(user.authenticate('New Password')).not_to be nil
      end
    end
  end
end
