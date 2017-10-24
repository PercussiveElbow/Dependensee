require 'rails_helper'

RSpec.describe Project, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:language) }
  it { should validate_presence_of(:owner) }
  it { should have_many(:scans) }
end