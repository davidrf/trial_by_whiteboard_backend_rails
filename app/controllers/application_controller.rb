class ApplicationController < ActionController::API
  def warden
    @warden ||= request.env["warden"]
  end

  def current_user
    @current_user ||= warden.authenticate if warden
  end
end
