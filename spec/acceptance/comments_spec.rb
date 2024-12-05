# require 'rails_helper'
# require 'rspec_api_documentation/dsl'

# resource "Comments" do
#   header "Content-Type", "application/json"
#   header "Accept", "application/json"

#   let!(:user) { User.create(name: "Test User", email: "test@example.com") }
#   let!(:post) { user.posts.create(title: "Test Post", body: "This is a test post.") }
#   let!(:comment) { post.comments.create(body: "Test comment", user: user) }

#   post "/api/v1/posts/:post_id/comments" do
#     parameter :body, "Body of the comment", required: true
#     parameter :user_id, "ID of the associated user", required: true

#     let(:post_id) { post.id }
#     let(:body) { "This is a comment." }
#     let(:user_id) { user.id }

#     example "Create a comment" do
#       do_request
#       expect(status).to eq 201
#       response = JSON.parse(response_body)
#       expect(response["body"]).to eq body
#     end
#   end

#   delete "/api/v1/posts/:post_id/comments/:id" do
#     let(:post_id) { post.id }
#     let(:id) { comment.id }

#     example "Delete a comment" do
#       do_request
#       expect(status).to eq 204
#     end
#   end
# end


require 'rails_helper'
require 'rspec_api_documentation/dsl'

resource "Comments" do
  header "Content-Type", "application/json"
  header "Accept", "application/json"

  let!(:user) { User.create(name: "Test User", email: "test@example.com", password: "password123", password_confirmation: "password123") }
  let!(:auth_token) { user.regenerate_auth_token; user.auth_token }
  let!(:post) { user.posts.create(title: "Test Post", body: "This is a test post.") }
  let!(:comment) { post.comments.create(body: "Test comment", user: user) }

  # Automatically include the Authorization header for authenticated requests
  before do
    header "Authorization", "Bearer #{auth_token}"
  end

  post "/api/v1/posts/:post_id/comments" do
    parameter :body, "Body of the comment", required: true

    let(:post_id) { post.id }
    let(:body) { "This is a new comment." }

    example "Create a comment" do
      do_request(comment: { body: body, user_id: user.id })
      expect(status).to eq 201
      response = JSON.parse(response_body)
      expect(response["body"]).to eq body
    end
  end

  delete "/api/v1/posts/:post_id/comments/:id" do
    let(:post_id) { post.id }
    let(:id) { comment.id }

    example "Delete a comment" do
      do_request
      expect(status).to eq 204
    end
  end
end
