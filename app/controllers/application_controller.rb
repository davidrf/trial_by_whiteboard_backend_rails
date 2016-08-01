class ApplicationController < ActionController::API
  def warden
    @warden ||= request.env["warden"]
  end

  def current_user
    if warden
      @current_user ||= warden.authenticate(:token_authentication_strategy)
    end
  end
end
