FactoryBot.define do
  factory :monthly_report do
    data { "MyText" }
    total_hour { 1.5 }
    total_days { 1 }
    average_hour { 1.5 }
    period_month { 1 }
    period_year { 2018 }
    user { nil }
  end
end
