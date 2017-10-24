require 'rails_helper'

RSpec.describe Scan, type: :model do
  it { should belong_to(:project) }
  it { should have_many(:dependencies).dependent(:destroy) }
end
