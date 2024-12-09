# frozen_string_literal: true

class Api::V1::RegistrationsController < ApplicationController
    def create
      user = User.new(user_params)
  
      if user.save
        sign_in(user)
        token = JwtService.encode({ user_id: user.id, exp: 24.hours.from_now.to_i })
        render json: { token: token, user: user }, status: :created
      else
        invalid_resource_error user
      end
    end

    private

    def user_params
      params.require(:user).permit(:email, :user_name, :password, :password_confirmation)
    end
end
  