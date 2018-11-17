require 'rails_helper'

RSpec.describe Record, type: :model do
  describe 'Model' do
    it 'is valid with factory creation' do
      expect(build(:record)).to be_valid
    end

    it 'should have user association' do
      is_expected.to belong_to(:user)
    end
  end
end
