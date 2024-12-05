# frozen_string_literal: true

class ApplicationController < ActionController::Base
    skip_before_action :verify_authenticity_token

    def authenticate_user!
        token = request.headers['Authorization']&.split(' ')&.last
        decoded_token = JwtService.decode(token)
        if decoded_token.nil?
            render json: { error: 'Not Authorized' }, status: :unauthorized
        else
            @current_user = User.find(decoded_token[:user_id])
        end
    end

    private def api_error(status, message)
        render status: status, json: { error: status, error_description: message }
      end

    private def invalid_resource_error(resource)
        message = resource.errors.to_hash
        api_error :unprocessable_entity, message
    end
  
    private def record_not_found_error
        api_error :not_found, 'Record Not found'
    end
end
