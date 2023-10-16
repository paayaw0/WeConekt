require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:text) }
  end

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:room) }
  end
end
