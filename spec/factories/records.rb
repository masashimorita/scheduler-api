FactoryBot.define do
  factory :record do
    start_at { "2018-01-01 00:00:00" }
    end_at { "2018-01-01 12:00:00" }
    record_date { "2018-01-01" }
    worked_hour { 12 }
    user { nil }
  end
end
