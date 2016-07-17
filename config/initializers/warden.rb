Rails.application.config.middleware.use Warden::Manager do |manager|
  manager.failure_app = lambda { |env|
    [
      401,
      { "Content-Type" => "application/json" },
      [{ authentication_token: env["warden"].message }.to_json]
    ]
  }
end

Warden::Strategies.add(:token_authentication_strategy) do
  def valid?
    http_authorization.present?
  end

  def authenticate!
    if user && !token_expired?
      success! user
    elsif user
      fail "expired"
    else
      fail "not found"
    end
  end

  def store?
    false
  end

  def authentication_token
    http_authorization.sub("Token token=", "")
  end

  def http_authorization
    @http_authorization ||= env["HTTP_AUTHORIZATION"]
  end

  def user
    @user ||= User.find_by(authentication_token: authentication_token)
  end

  def token_expired?
    user.authentication_token_expires_at <= Time.current
  end
end
