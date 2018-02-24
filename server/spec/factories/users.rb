FactoryGirl.define do
  factory :user do
    name { Faker::Name.first_name }
    email { Faker::Internet.email}
    password 'apassword'
  end
end