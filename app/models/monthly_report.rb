class MonthlyReport < ApplicationRecord
  belongs_to :user

  validates_presence_of :data, :total_hour, :total_days, :average_hour, :period_month, :period_year
end
