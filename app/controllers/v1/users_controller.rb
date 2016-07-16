class V1::UsersController < V1::ApplicationController
  def create
    user = User.new(user_params)
    user.set_new_unique_authentication_token
    if user.save
      render json: user, serializer: AuthenticationSerializer, status: :created
    else
      render json: user.errors, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :username)
  end
end
