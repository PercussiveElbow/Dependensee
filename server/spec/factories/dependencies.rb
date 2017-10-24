FactoryGirl.define do
  factory :dependency do
    name { Faker::Lorem::word }
    version { Faker::Number.digit }
    language { Faker::Lorem::word }
    raw { Faker::Lorem::word } #this should be replaced with fake gemfile contents or similar
    scan_id nil
  end
end