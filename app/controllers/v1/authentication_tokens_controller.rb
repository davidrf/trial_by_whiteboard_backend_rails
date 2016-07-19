class V1::AuthenticationTokensController < V1::ApplicationController
  before_action :set_user, only: [:create]

  def create
    if @user.authenticate(user_params[:password])
      @user.set_new_unique_authentication_token
      @user.save
      render json: @user, serializer: AuthenticationSerializer, status: :ok
    else
      render json: { password: "invalid" }, status: :unprocessable_entity
    end
  end

  def destroy
    current_user.authentication_token_expires_at = Time.current
    current_user.save
    head :no_content
  end

  private

  def user_params
    params.require(:user).permit(:username, :password)
  end

  def set_user
    @user = User.find_by!(username: user_params[:username])
  end
end
