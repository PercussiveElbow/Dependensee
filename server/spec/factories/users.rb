FactoryGirl.define do
  factory :user do
    name { Faker::Name.first_name }
    email 'test@example.com'
    password 'apassword'
  end
end