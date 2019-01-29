class MonthlyReport < ApplicationRecord
  belongs_to :user

  validates_presence_of :data, :total_hour, :total_days, :average_hour, :period_month, :period_year

  def add_daily_report(record)
    records = JSON.parse(self.data)
    records << {
        worked_hour: record.worked_hour,
        record_date: record.record_date,
        start_at: record.start_at,
        end_at: record.end_at
    }
    self.data = records.to_json
    self.total_hour = self.total_hour.to_f + record.worked_hour.to_f
    self.total_days = self.total_days.to_i + 1
    self.average_hour = self.total_hour / self.total_days.to_f
    save!
  end

  def recalculate_report(record, previous_date)
    records = JSON.parse(self.data)
    days, hour = 0, 0
    records = records.map do |item|
      unless item["record_date"].to_date == previous_date
        days += 1
        hour += item["worked_hour"].to_f
        item
      end
    end
    records = records.compact
    records ||= []
    records << {
        worked_hour: record.worked_hour,
        record_date: record.record_date,
        start_at: record.start_at,
        end_at: record.end_at
    }
    self.data = records.to_json
    self.total_hour = hour.to_f + record.worked_hour.to_f
    self.total_days = days.to_i + 1
    self.average_hour = self.total_hour / self.total_days.to_f
    save!
  end

  def recalculate_all(records)
    days, hour = 0, 0
    new_data = records.map do |record|
      days += 1
      hour += record["worked_hour"].to_f

      {
          worked_hour: record.worked_hour,
          record_date: record.record_date,
          start_at: record.start_at,
          end_at: record.end_at
      }
    end
    self.data = new_data.to_json
    self.total_hour = hour.to_f
    self.total_days = days.to_i
    self.average_hour = self.total_hour / self.total_days.to_f
    save!
  end
end
