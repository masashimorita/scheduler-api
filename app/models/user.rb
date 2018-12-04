class User < ApplicationRecord
  before_save { email.downcase! }

  has_secure_password

  has_many :remember_tokens
  has_many :records
  has_many :monthly_reports

  validates :name, presence: true, length: { maximum: 50 }
  validates :email, presence: true, length: { maximum: 255 },
                                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
                                    uniqueness: { case_sensitive: false }
  validates :target_hour, allow_blank: true, numericality: { greater_than: 0, only_integer: true }
  validates :check_in_period, allow_blank: true, numericality: { less_than_or_equal_to: 60, greater_than_or_equal_to: 0 }

  def change_password!(current_password, new_password)
    return false unless self.authenticate(current_password)
    self.password = new_password
    save!
  end
end
