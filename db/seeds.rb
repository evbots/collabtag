(1..4).each do |i|
  new_user = User.new(email: "user#{i}@test.com", username: "user#{i}", password: 'password123')
  new_user.save!
end

HelperTasks.seed_schools
