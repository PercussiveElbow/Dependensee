
FactoryGirl.define do
  factory :project do
    name {Faker::Lorem.word}
    owner {Faker::Lorem.word}
    language {Faker::Lorem.word}
  end
end