# require 'rails_helper'
# require 'rspec_api_documentation/dsl'

# resource "Posts" do
#   header "Content-Type", "application/json"
#   header "Accept", "application/json"

#   let!(:user) { User.create(name: "Test User", email: "test@example.com") }
#   let!(:post) { user.posts.create(title: "Test Post", body: "This is a test post.") }

#   get "/api/v1/posts" do
#     example "List all posts" do
#       do_request
#       expect(status).to eq 200
#       response = JSON.parse(response_body)
#       expect(response.size).to eq 1
#     end
#   end

#   get "/api/v1/posts/:id" do
#     let(:id) { post.id }

#     example "Get a specific post" do
#       do_request
#       expect(status).to eq 200
#       response = JSON.parse(response_body)
#       expect(response["id"]).to eq post.id
#       expect(response["title"]).to eq post.title
#     end
#   end

#   post "/api/v1/posts" do
#     parameter :title, "Title of the post", required: true
#     parameter :body, "Body of the post", required: true
#     parameter :user_id, "ID of the associated user", required: true

#     let(:title) { "New Post" }
#     let(:body) { "This is a new post." }
#     let(:user_id) { user.id }

#     example "Create a post" do
#       do_request
#       expect(status).to eq 201
#       response = JSON.parse(response_body)
#       expect(response["title"]).to eq title
#     end
#   end

#   delete "/api/v1/posts/:id" do
#     let(:id) { post.id }

#     example "Delete a post" do
#       do_request
#       expect(status).to eq 204
#     end
#   end
# end


require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Posts" do
  header "Content-Type", "application/json"
  header "Accept", "application/json"

  let!(:user) { User.create(name: "Test User", email: "test@example.com", password: "password123", password_confirmation: "password123") }
  let!(:auth_token) { user.regenerate_auth_token; user.auth_token }
  let!(:post) { user.posts.create(title: "Test Post", body: "This is a test post.") }

  # Automatically include the Authorization header for all authenticated requests
  before do
    header "Authorization", "Bearer #{auth_token}"
  end

  get "/api/v1/posts" do
    example "List all posts" do
      do_request
      expect(status).to eq 200
      response = JSON.parse(response_body)
      expect(response.size).to eq 1
      expect(response.first["title"]).to eq(post.title)
    end
  end

  get "/api/v1/posts/:id" do
    let(:id) { post.id }

    example "Get a specific post" do
      do_request
      expect(status).to eq 200
      response = JSON.parse(response_body)
      expect(response["id"]).to eq post.id
      expect(response["title"]).to eq post.title
    end
  end

  post "/api/v1/posts" do
    parameter :title, "Title of the post", required: true
    parameter :body, "Body of the post", required: true

    let(:title) { "New Post" }
    let(:body) { "This is a new post." }

    example "Create a post" do
      do_request(post: { title: title, body: body, user_id: user.id })
      expect(status).to eq 201
      response = JSON.parse(response_body)
      expect(response["title"]).to eq title
    end
  end

  delete "/api/v1/posts/:id" do
    let(:id) { post.id }

    example "Delete a post" do
      do_request
      expect(status).to eq 204
    end
  end
end
