
# frozen_string_literal: true

class Api::V1::SessionsController < Devise::SessionsController
    def create
      user = User.find_for_database_authentication(email: params[:user][:email])
  
      if user&.valid_password?(params[:user][:password])
        sign_in(user)
        token = JwtService.encode({ user_id: user.id, exp: 24.hours.from_now.to_i })
        render json: { token: token, user_name: user.user_name }, status: :ok
      else
        api_error(:unauthorized, 'Invalid email or password')
      end
    end

    def destroy
        render json: { message: 'Successfully signed out' }, status: :ok
    end
end
  