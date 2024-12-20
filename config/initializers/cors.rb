# frozen_string_literal: true

Rails.application.config.middleware.insert_before 0, Rack::Cors do
    allow do
      origins '*'
      resource '*', headers: :any, methods: %i[get post put delete options]
    end
  
    allow do
        resource '/api/*',
        headers: :any,
        methods: :any
    end
end