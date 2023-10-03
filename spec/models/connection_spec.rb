require 'rails_helper'

RSpec.describe Connection, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:room) }
  it { should have_many(:messages) }
end
