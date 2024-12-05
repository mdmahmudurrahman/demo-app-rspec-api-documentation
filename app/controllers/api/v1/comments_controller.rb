module Api
  module V1
    class CommentsController < ApplicationController
      before_action :set_post
      before_action :set_comment, only: [:destroy]

      # POST /api/v1/posts/:post_id/comments
      def create
        comment = @post.comments.build(comment_params)
        comment.user = current_user # Use the authenticated user
      
        if comment.save
          render json: comment, status: :created
        else
          render json: comment.errors, status: :unprocessable_entity
        end
      end
      
      # DELETE /api/v1/posts/:post_id/comments/:id
      def destroy
        if @comment.destroy
          head :no_content
        else
          render json: { error: 'Failed to delete comment' }, status: :unprocessable_entity
        end
      end

      private

      # Find the associated post
      def set_post
        @post = Post.find(params[:post_id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Post not found' }, status: :not_found
      end

      # Find the specific comment for destroy action
      def set_comment
        @comment = @post.comments.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Comment not found' }, status: :not_found
      end

      # Strong parameters for comment creation
      def comment_params
        params.require(:comment).permit(:body, :user_id)
      end
    end
  end
end
