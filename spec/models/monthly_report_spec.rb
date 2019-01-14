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
      let!(:prev_record) { create(:record, user: report.user, default_start_at: Time.current.yesterday, default_end_at: (Time.current.yesterday + 2.hour), default_worked_hour: 2.0, default_record_date: Time.current.yesterday) }

      it 'should add daily record' do
        report.add_daily_report(record)
        expect(JSON.parse(report.data).length).to eq 2
      end

      it 'should recalculate record' do
        report.add_daily_report(prev_record)
        prev_record.worked_hour = prev_record.worked_hour.to_f - 1
        prev_record.save!
        previous_total = report.total_hour.to_i

        report.recalculate_report(prev_record, prev_record.record_date)
        expect(report.total_hour.to_i).to eq previous_total - 1
      end
    end
  end
end
