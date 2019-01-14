class MonthlyReport < ApplicationRecord
  belongs_to :user

  validates_presence_of :data, :total_hour, :total_days, :average_hour, :period_month, :period_year

  def add_daily_report(record)
    records = JSON.parse(self.data)
    records << {
        worked_hour: record.worked_hour,
        record_date: record.record_date
    }
    self.data = records.to_json
    self.total_hour = self.total_hour.to_f + record.worked_hour.to_f
    self.total_days = self.total_days.to_i + 1
    self.average_hour = self.total_hour / self.total_days.to_f
    save!
  end
end
