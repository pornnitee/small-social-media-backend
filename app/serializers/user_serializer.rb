# frozen_string_literal: true

class UserSerializer
    include FastJsonapi::ObjectSerializer
  
    attributes :id, :user_name, :email
end
  