module Api
  module V1
    module Admin
      class AuthorsController < ApplicationController
        before_action :authenticate_user!
        before_action :set_author, only: [:show, :update, :destroy]

        # GET /api/v1/admin/authors
        def index
          authors = Author.all
          render json: authors, status: :ok
        end

        # GET /api/v1/admin/authors/:id
        def show
          render json: @author, status: :ok
        end

        # POST /api/v1/admin/authors
        def create
          author = Author.new(author_params)
          if author.save
            render json: author, status: :created
          else
            render json: author.errors, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/authors/:id
        def update
          if @author.update(author_params)
            render json: @author, status: :ok
          else
            render json: @author.errors, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/authors/:id
        def destroy
          @author.destroy
          head :no_content
        end

        private

        def set_author
          @author = Author.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Author not found' }, status: :not_found
        end

        def author_params
          params.require(:author).permit(:name, :biography)
        end
      end
    end
  end
end
