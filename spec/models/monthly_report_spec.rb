require 'rails_helper'

RSpec.describe MonthlyReport, type: :model do
  describe 'Model' do
    it 'is valid with factory creation' do
      expect(build(:monthly_report)).to be_valid
    end

    it 'should have user association' do
      is_expected.to belong_to(:user)
    end

    describe 'ActiveModel Validation' do
      it { is_expected.to validate_presence_of :data }
      it { is_expected.to validate_presence_of :total_hour }
      it { is_expected.to validate_presence_of :total_days }
      it { is_expected.to validate_presence_of :average_hour }
      it { is_expected.to validate_presence_of :period_month }
      it { is_expected.to validate_presence_of :period_year }
    end

    describe 'class methods' do
      let!(:report) { create(:monthly_report) }
      let!(:record) { create(:record, user: report.user) }

      it 'should add daily record' do
        report.add_daily_report(record)
        pp report
        expect(JSON.parse(report.data).length).to eq 2
      end
    end
  end
end
