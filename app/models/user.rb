class User < ApplicationRecord
  has_many :questions, dependent: :destroy

  has_secure_password

  validates :authentication_token, presence: true, uniqueness: true
  validates :authentication_token_expires_at, presence: true
  validates :email, presence: true, uniqueness: true
  validates :username, presence: true, uniqueness: true

  def set_new_unique_authentication_token
    set_new_authentication_token until authentication_token.present? && authentication_token_unique?
    set_new_authentication_token_expires_at
  end

  private

  def authentication_token_unique?
    User.where(authentication_token: authentication_token).none?
  end

  def set_new_authentication_token
    self.authentication_token = self.class.generate_unique_secure_token
  end

  def set_new_authentication_token_expires_at
    self.authentication_token_expires_at = authentication_token_duration.days.from_now
  end

  def authentication_token_duration
    ENV.fetch("AUTHENTICATION_TOKEN_DURATION_IN_DAYS") { 7 }.to_i
  end
end
