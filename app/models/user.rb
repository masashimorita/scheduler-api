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

  def change_password!(current_password, new_password)
    return false unless self.authenticate(current_password)
    self.password = new_password
    save!
  end
end
