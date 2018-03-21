# spec/models/dependency_spec.rb
require 'rails_helper'

RSpec.describe Dependency, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:version)}
end