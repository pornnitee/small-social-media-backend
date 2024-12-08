# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::PostsController, type: :controller do
  let(:user) { User.create!(user_name: 'Test User', email: 'test@example.com', password: 'password') }
  let(:other_user) { User.create!(user_name: 'Other User', email: 'other@example.com', password: 'password') }
  let!(:post) { user.posts.create!(title: 'Test Title', body: 'Test Body') }

  before do
    allow(controller).to receive(:authenticate_user!).and_return(true)
    allow(controller).to receive(:current_user).and_return(user)
  end

  describe 'GET #index' do
    it 'returns a list of posts' do
      get :index
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']).not_to be_empty
    end
  end

  describe 'GET #show' do
    context 'when the post exists' do
      it 'returns the requested post' do
        get :show, params: { id: post.id }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['id']).to eq(post.id.to_s)
      end
    end

    context 'when the post does not exist' do
      it 'returns a not found error' do
        get :show, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new post' do
        post_params = { title: 'New Post', body: 'New Body' }
        process :create, method: :post, params: { post: post_params }
        title = JSON.parse(response.body)['data']["attributes"]["title"]
        body = JSON.parse(response.body)['data']["attributes"]["body"]
        expect(response).to have_http_status(:ok)
        expect(title).to eq(post_params[:title])
        expect(body).to eq(post_params[:body])
      end
    end
  end

  describe 'PUT #update' do
    context 'when the user owns the post' do
      it 'updates the post' do
        update_params = { title: 'Updated Title' }
        put :update, params: { id: post.id, post: update_params }
        expect(response).to have_http_status(:ok)
        expect(post.reload.title).to eq('Updated Title')
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'when the user owns the post' do
      it 'deletes the post' do
        expect {
          delete :destroy, params: { id: post.id }
        }.to change(Post, :count).by(-1)
        expect(response).to have_http_status(:ok)
      end
    end
  end
end
