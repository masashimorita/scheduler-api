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
      default_data { "[{date: '2018-11-01', hour: 4}]" }
      default_total_hour { 4 }
      default_days { 1 }
      default_average_hour { 4 }
      default_period_month { 11 }
      default_period_year { 2018 }
      default_user { create(:user) }
    end
  end
end
