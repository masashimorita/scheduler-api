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

  describe 'class methods' do
    let(:period) { 15 }
    let!(:time) { Time.current.change(min: 23) }
    let!(:record) { create(:record, default_start_at: time.change(hour: 8), default_end_at: time.change(hour: 19)) }
    it 'should calculate check in time with period' do
      expect(Record.calculate_time(check_in: true, current: time, period: period)).to eq time.change(min: 30)
    end

    it 'should calculate check out time with period' do
      expect(Record.calculate_time(check_in: false, current: time, period: period)).to eq time.change(min: 15)
    end

    it 'calculate work hour' do
      expect(record.calculate_work_hour(break_hour: 1)).to eq 10
    end
  end
end
