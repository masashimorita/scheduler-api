FactoryBot.define do
  factory :user do
    sequence(:email) {|i| i.to_s + default_email }
    name { default_name }
    password { default_password }
    target_hour { default_target_hour }
    check_in_period { default_check_in_period }
    break_hour { default_break_hour }

    transient do
      default_email { 'example@example.com' }
      default_name { 'example' }
      default_password { 'example' }
      default_target_hour { 100 }
      default_check_in_period { rand(60) }
      default_break_hour { rand(10) }
    end
  end
end
