class Record < ApplicationRecord
  belongs_to :user

  def self.calculate_time(check_in: false, current: Time.current, period: 1)
    minutes = (current.min.to_f / period.to_f)
    minutes = (check_in ? minutes.ceil : minutes.floor) * period
    if minutes >= 60
      minutes = 0
      current += 1.hours
    end
    current.change(min: minutes)
  end

  def calculate_work_hour(break_hour: 1, had_break: true)
    worked_hour = (self.end_at - self.start_at) / 3600
    worked_hour -= break_hour if (worked_hour > break_hour) && had_break
    worked_hour
  end
end
