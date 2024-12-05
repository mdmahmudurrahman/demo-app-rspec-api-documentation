require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Admin/Books" do
  header "Content-Type", "application/json"
  header "Accept", "application/json"

  let!(:user) { User.create(name: "Admin User", email: "admin@example.com", password: "password123", password_confirmation: "password123") }
  let!(:auth_token) { user.regenerate_auth_token; user.auth_token }
  let!(:book) { Book.create(title: "Book Title", author: "Author Name", description: "Book description.", published_at: "2024-12-03") }

  before do
    header "Authorization", "Bearer #{auth_token}"
  end

  get "/api/v1/admin/books" do
    example "List all books" do
      do_request
      expect(status).to eq(200)
      response = JSON.parse(response_body)
      expect(response.size).to eq(1)
      expect(response.first["title"]).to eq(book.title)
    end
  end

  get "/api/v1/admin/books/:id" do
    let(:id) { book.id }

    example "Get a book" do
      do_request
      expect(status).to eq(200)
      response = JSON.parse(response_body)
      expect(response["title"]).to eq(book.title)
    end
  end

  post "/api/v1/admin/books" do
    parameter :title, "Title of the book", required: true
    parameter :author, "Author of the book", required: true
    parameter :description, "Description of the book"
    parameter :published_at, "Published date of the book"

    let(:title) { "New Book" }
    let(:author) { "New Author" }
    let(:description) { "New book description." }
    let(:published_at) { "2024-12-04" }

    example "Create a book" do
      do_request(book: { title: title, author: author, description: description, published_at: published_at })
      expect(status).to eq(201)
      response = JSON.parse(response_body)
      expect(response["title"]).to eq(title)
    end
  end

  put "/api/v1/admin/books/:id" do
    let(:id) { book.id }
    parameter :title, "Title of the book", required: true
    parameter :author, "Author of the book", required: true
    parameter :description, "Description of the book"
    parameter :published_at, "Published date of the book"

    let(:title) { "Updated Book" }
    let(:author) { "Updated Author" }
    let(:description) { "Updated description." }
    let(:published_at) { "2024-12-05" }

    example "Update a book" do
      do_request(book: { title: title, author: author, description: description, published_at: published_at })
      expect(status).to eq(200)
      response = JSON.parse(response_body)
      expect(response["title"]).to eq(title)
    end
  end

  delete "/api/v1/admin/books/:id" do
    let(:id) { book.id }

    example "Delete a book" do
      do_request
      expect(status).to eq(204)
    end
  end
end
