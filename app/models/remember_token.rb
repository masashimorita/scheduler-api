class RememberToken < ApplicationRecord
  belongs_to :user

  validates :code, presence: true
  validates :expired_at, presence: true
  validates :email, presence: true, format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  def self.generate_code (length)
    SecureRandom.hex(length)
  end
end
