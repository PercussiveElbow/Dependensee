require 'rails_helper'

RSpec.describe PythonCve, type: :model do
  it { should validate_presence_of(:cve_id) }
end
