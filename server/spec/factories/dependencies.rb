FactoryBot.define do
  factory :dependency do
    name { Faker::Lorem::word }
    version { Faker::Number.digit }
    raw { Faker::Lorem::word }
    scan_id nil
  end
end