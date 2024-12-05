require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Admin/Authors" do
  header "Content-Type", "application/json"
  header "Accept", "application/json"

  let!(:user) { User.create(name: "Admin User", email: "admin@example.com", password: "password123", password_confirmation: "password123") }
  let!(:auth_token) { user.regenerate_auth_token; user.auth_token }
  let!(:author) { Author.create(name: "Author Name", biography: "Author biography.") }

  before do
    header "Authorization", "Bearer #{auth_token}"
  end

  get "/api/v1/admin/authors" do
    example "List all authors" do
      do_request
      expect(status).to eq(200)
      response = JSON.parse(response_body)
      expect(response.size).to eq(1)
      expect(response.first["name"]).to eq(author.name)
    end
  end

  get "/api/v1/admin/authors/:id" do
    let(:id) { author.id }

    example "Get an author" do
      do_request
      expect(status).to eq(200)
      response = JSON.parse(response_body)
      expect(response["name"]).to eq(author.name)
    end
  end

  post "/api/v1/admin/authors" do
    parameter :name, "Name of the author", required: true
    parameter :biography, "Biography of the author", required: true

    let(:name) { "New Author" }
    let(:biography) { "Biography of the new author." }

    example "Create an author" do
      do_request(author: { name: name, biography: biography })
      expect(status).to eq(201)
      response = JSON.parse(response_body)
      expect(response["name"]).to eq(name)
    end
  end

  put "/api/v1/admin/authors/:id" do
    let(:id) { author.id }
    parameter :name, "Name of the author", required: true
    parameter :biography, "Biography of the author", required: true

    let(:name) { "Updated Author" }
    let(:biography) { "Updated biography." }

    example "Update an author" do
      do_request(author: { name: name, biography: biography })
      expect(status).to eq(200)
      response = JSON.parse(response_body)
      expect(response["name"]).to eq(name)
    end
  end

  delete "/api/v1/admin/authors/:id" do
    let(:id) { author.id }

    example "Delete an author" do
      do_request
      expect(status).to eq(204)
    end
  end
end
