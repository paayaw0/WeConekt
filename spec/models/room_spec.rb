require 'rails_helper'

RSpec.describe Room, type: :model do
  it { 
    should define_enum_for(:room_type)
    .with_values(single: 0, group: 1).with_prefix
    .without_scopes
    .backed_by_column_of_type(:integer) 
  }

  it { should have_many(:connections) }
  it { should have_many(:users).through(:connections) }
  it { should have_many(:messages) }
end
