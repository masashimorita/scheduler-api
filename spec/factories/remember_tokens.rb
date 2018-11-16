FactoryBot.define do
  factory :remember_token do
    code { default_code }
    email { default_email }
    user { default_user }
    expired_at { default_expired_at }

    transient do
      default_code { RememberToken::generate_code(13) }
      default_user { create(:user) }
      default_email { default_user.email }
      default_expired_at { DateTime.now }
    end
  end
end
