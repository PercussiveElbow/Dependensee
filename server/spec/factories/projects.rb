
FactoryGirl.define do
  factory :project do
    name {'ATestProject'}
    owner {Faker::Lorem.word}
    language {'Java'}
  end
end