require 'rails_helper'

RSpec.describe RememberToken, type: :model do
  describe 'Model' do
    it 'is valid with factory creation' do
      expect(build(:remember_token)).to be_valid
    end

    it 'should have user association' do
      is_expected.to belong_to(:user)
    end

    describe 'ActiveModel Validation' do
      it { is_expected.to validate_presence_of :code }
      it { is_expected.to validate_presence_of :expired_at }
      it { is_expected.to validate_presence_of :email }
      it { is_expected.to_not allow_value('example@example').for :email }
    end

    describe 'class methods' do
      it { expect(RememberToken).to respond_to(:generate_code) }
      it { expect(RememberToken.generate_code(13).length).to eq (13 * 2) }
    end
  end
end
