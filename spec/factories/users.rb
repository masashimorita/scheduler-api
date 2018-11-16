FactoryBot.define do
  factory :user do
    email { default_email }
    name { default_name }
    password { default_password }
    target_hour { default_target_hour }

    transient do
      default_email { 'example@example.com' }
      default_name { 'example' }
      default_password { 'example' }
      default_target_hour { 100 }
    end
  end
end
