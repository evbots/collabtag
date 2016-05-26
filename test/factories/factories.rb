FactoryGirl.define do
  factory :user do
    email 'test@test.com'
    username 'test'
    password 'testing123'
  end

  factory :group do
    name 'fancy group'
    user_id 1
  end
end
