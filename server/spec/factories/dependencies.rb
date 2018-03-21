FactoryBot.define do
  factory :dependency do
    name { Faker::Lorem::word }
    version { Faker::Number.digit }
    raw { Faker::Lorem::word } #this should be replaced with fake gemfile contents or similar
    scan_id nil
  end
end