module Api
  module V1
    module Admin
      class BooksController < ApplicationController
        before_action :authenticate_user!
        before_action :set_book, only: [:show, :update, :destroy]

        # GET /api/v1/admin/books
        def index
          books = Book.all
          render json: books, status: :ok
        end

        # GET /api/v1/admin/books/:id
        def show
          render json: @book, status: :ok
        end

        # POST /api/v1/admin/books
        def create
          book = Book.new(book_params)
          if book.save
            render json: book, status: :created
          else
            render json: book.errors, status: :unprocessable_entity
          end
        end

        # PUT /api/v1/admin/books/:id
        def update
          if @book.update(book_params)
            render json: @book, status: :ok
          else
            render json: @book.errors, status: :unprocessable_entity
          end
        end

        # DELETE /api/v1/admin/books/:id
        def destroy
          @book.destroy
          head :no_content
        end

        private

        def set_book
          @book = Book.find(params[:id])
        rescue ActiveRecord::RecordNotFound
          render json: { error: 'Book not found' }, status: :not_found
        end

        def book_params
          params.require(:book).permit(:title, :author, :description, :published_at)
        end
      end
    end
  end
end
