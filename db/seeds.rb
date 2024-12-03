# Clear existing data
Comment.destroy_all
Post.destroy_all
User.destroy_all

# Create Users
users = []
5.times do |i|
  users << User.create!(
    name: "User #{i + 1}",
    email: "user#{i + 1}@example.com"
  )
end
puts "Created #{users.size} users."

# Create Posts
posts = []
users.each do |user|
  3.times do |i|
    posts << user.posts.create!(
      title: "Post #{i + 1} by #{user.name}",
      body: "This is the body of post #{i + 1} created by #{user.name}."
    )
  end
end
puts "Created #{posts.size} posts."

# Create Comments
comments = []
posts.each do |post|
  2.times do
    comments << post.comments.create!(
      body: "This is a comment on #{post.title}.",
      user: users.sample # Randomly assign a user as the commenter
    )
  end
end
puts "Created #{comments.size} comments."

puts "Seeding complete!"
