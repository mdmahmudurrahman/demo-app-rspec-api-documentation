module Api
  module V1
    class PostsController < ApplicationController
      before_action :set_post, only: [:show, :update, :destroy]

      # GET /api/v1/posts
      def index
        posts = Post.includes(:user, :comments).all
        render json: posts, include: {
          user: { only: [:id, :name, :email] },
          comments: {
            include: { user: { only: [:id, :name, :email] } },
            only: [:id, :body, :created_at]
          }
        }, status: :ok
      end

      # GET /api/v1/posts/:id
      def show
        render json: @post, include: { user: { only: [:id, :name, :email] } }, status: :ok
      end

      # POST /api/v1/posts
      def create
        post = Post.new(post_params)
        post.user = User.find(params[:user_id]) if params[:user_id].present? # Link to a user

        if post.save
          render json: post, status: :created
        else
          render json: post.errors, status: :unprocessable_entity
        end
      end

      # PUT/PATCH /api/v1/posts/:id
      def update
        if @post.update(post_params)
          render json: @post, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      # DELETE /api/v1/posts/:id
      def destroy
        @post.destroy
        head :no_content
      end

      private

      # Find a specific post
      def set_post
        @post = Post.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Post not found' }, status: :not_found
      end

      # Strong parameters
      def post_params
        params.require(:post).permit(:title, :body, :user_id)
      end
    end
  end
end
