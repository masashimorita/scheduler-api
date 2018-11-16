FactoryBot.define do
  factory :record do
    start_at { default_start_at }
    end_at { default_end_at }
    record_date { default_record_date }
    worked_hour { default_worked_hour }
    user { default_user }

    transient do
      default_start_at { DateTime.now }
      default_end_at { DateTime.now + 1.hour }
      default_record_date { Date.today }
      default_worked_hour { 1 }
      default_user { create(:user) }
    end
  end
end
