FactoryGirl.define do
  factory :scan do
    source { Faker::Lorem::word }
    project_id nil
    needs_update 'no'
  end
end