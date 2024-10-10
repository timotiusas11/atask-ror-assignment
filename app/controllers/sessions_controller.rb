require 'jwt'

class SessionsController < ApplicationController
  # POST /login
  def create
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      token = JWT.encode({ user_id: user.id }, Rails.application.credentials.jwt_secret, 'HS256')
      render json: { token: token }, status: :ok
    else
      render json: { error: 'Invalid email or password' }, status: :unauthorized
    end
  end

  # DELETE /logout
  def destroy
    # Log out logic, e.g., delete token
    render json: { message: 'Logout successful' }, status: :ok
  end

  private

  def generate_token(user)
    JWT.encode({ user_id: user.id, exp: 24.hours.from_now.to_i }, Rails.application.credentials.secret_key_base)
  end
end
