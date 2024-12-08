# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::RegistrationsController, type: :controller do
  describe 'POST #create' do
    context 'with valid parameters' do
      let(:valid_params) do
        {
          user: {
            email: 'test@example.com',
            user_name: 'Test User',
            password: 'password',
            password_confirmation: 'password'
          }
        }
      end

      it 'creates a new user' do
        expect {
          post :create, params: valid_params
        }.to change(User, :count).by(1)
        expect(response).to have_http_status(:created)
        body = JSON.parse(response.body)
        expect(body['token']).not_to be_nil
        expect(body['user']['email']).to eq('test@example.com')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            email: 'invalid-email',
            user_name: '',
            password: 'password',
            password_confirmation: 'mismatch'
          }
        }
      end
    end
  end
end
