### Users

User.create!(name: "Example User",
            email: "example@server.com",
            password: "password",
            password_confirmation: "password",
            admin: true,
            activated: true,
            activated_at: Time.zone.now)

99.times do |id|
    name = Faker::Name.name
    email = "example-#{id+1}@server.com"
    password = "password"
    User.create!(name: name,
                email: email,
                password: password,
                password_confirmation: password,
                activated: true,
                activated_at: Time.zone.now)
end

### Microposts

users = User.order(:created_at).take(6)

50.times do
    content = Faker::Lorem.sentence(5)
    users.each do |user|
        user.microposts.create!(content: content)
    end
end

### Following relationship

users = User.all
user = users.first
following = users[2..50]
followers = users[3..40]
following.each { |followed| user.follow(followed)}
followers.each { |follower| follower.follow(user)}