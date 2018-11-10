class Message
  def self.not_found(record = 'record')
    "Sorry #{record} not found..."
  end
  def self.invalid_credentials
    'Invalid credentials'
  end
  def self.invalid_token
    'Invalid token'
  end
  def self.missing_token
    'Missing token'
  end
  def unauthorized
    'Unauthorized request'
  end
  def self.account_created
    'Account created successfully'
  end
  def self.account_not_created
    'Account could not  be created'
  end
  def self.expired_token
    'Sorry, your token has expired. Please login to continue...'
  end
  def self.reset_password_has_requested
    'Password reset has requested successfully'
  end
  def self.password_not_match
    'Invalid Password was given'
  end
  def self.password_reset
    'Password has reset successfully'
  end
  def self.password_change
    'Password has changed successfully'
  end
end