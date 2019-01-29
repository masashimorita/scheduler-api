FactoryBot.define do
  factory :monthly_report do
    data { default_data }
    total_hour { default_total_hour }
    total_days { default_days }
    average_hour { default_average_hour }
    period_month { default_period_month }
    period_year { default_period_year }
    user { default_user }

    transient do
      default_data { ([{record_date: Date.today, worked_hour: 4, start_at: Time.current, end_at: Time.current + 4.hours}]).to_json }
      default_total_hour { 4 }
      default_days { 1 }
      default_average_hour { 4 }
      default_period_month { DateTime.now.month }
      default_period_year { DateTime.now.year }
      default_user { create(:user) }
    end
  end
end
