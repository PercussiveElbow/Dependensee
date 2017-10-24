require 'rails_helper'

RSpec.describe Cve, type: :model do
  it { should validate_presence_of(:dependency_name) }
  it { should validate_presence_of(:date) }
  it { should validate_presence_of(:desc)}
  it { should validate_presence_of(:cvss2)}
end
