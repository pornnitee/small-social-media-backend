# frozen_string_literal: true

class Api::V1::PostsController < ApplicationController
    before_action :authenticate_user!, except: [:index]
    before_action :set_post, only: [:show, :update, :destroy]

    def index
      @posts = Post.all
      render_json_api @posts.order('created_at DESC')
    end

    def show
        if @post.present?
            render_json_api @post
        else
            record_not_found_error
        end
    end

    def create
      @post = @current_user.posts.create(post_params)

      if @post.save
        render_json_api @post
      else
        invalid_resource_error @post
      end
    end

    def update
      if @post.update(post_params)
        render_json_api @post
      else
        invalid_resource_error @post
      end
    end

    def destroy
        render_json_api @post.destroy
    end

    private

    def render_json_api(data)
        render json: PostSerializer.new(data)
    end

    def set_post
      @post = @current_user.posts.find_by(id: params[:id])
    end

    def post_params
      params.require(:post).permit(:title, :body)
    end
end
