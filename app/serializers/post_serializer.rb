# frozen_string_literal: true

class PostSerializer
    include FastJsonapi::ObjectSerializer
  
    attributes :id, :title, :body, :user, :created_at
  end
  