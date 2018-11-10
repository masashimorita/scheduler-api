FactoryBot.define do
  factory :remember_token do
    code { "MyString" }
    email { "MyString" }
    user_id { nil }
  end
end
