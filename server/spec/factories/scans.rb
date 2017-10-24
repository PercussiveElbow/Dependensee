FactoryGirl.define do
  factory :scan do
    source { Faker::Lorem::word }
    project_id nil
  end
end