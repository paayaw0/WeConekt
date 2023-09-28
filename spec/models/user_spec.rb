require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { build(:user) }

    it { should have_secure_password(:password) }
    it { should validate_presence_of(:password) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email).case_insensitive }
    it { should allow_value('paayaw.dev@gmail.com', 'PAAYAW.DEV@GMAIL.COM').for(:email) }

    describe 'custom validators' do
      context 'StrongPasswordValidator' do
        let!(:without_an_uppercase) { 'h_elo90x%' }
        let!(:without_special_character) { 'He23xVwe' }

        it 'raise error if password is without at least one uppercase character' do
          user = build(:user, email: 'paayaw.dev@gmail.com', password: without_an_uppercase)
          expect{ user.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'raise error if password is without a special character' do
          user = build(:user, email: 'paayaw.dev@gmail.com', password: without_special_character)
          expect{ user.save! }.to raise_error(ActiveRecord::RecordInvalid)
        end

        it 'should have error messages' do
          user = build(:user, email: 'paayaw.dev@gmail.com', password: without_special_character)
          user.save

          expect(user.errors.full_messages[0]).to eq("Password must contain at least one uppercase letter, one lowercase letter, one number, and one special character")
        end
      end
    end
  end

  describe 'associations'
  describe 'callbacks' do
    context 'before_save callbacks' do
      it 'downcase email' do
        user = build(:user, email: 'PAAYAW.DEV@GMAIL.COM')

        user.run_callbacks(:save) { false }

        expect(user.email).to eq('paayaw.dev@gmail.com')
      end

      it 'sets temp username value from email prefix' do
        user = build(:user, email: 'paayaw.dev@gmail.com', username: nil)

        user.run_callbacks(:save) { false }

        expect(user.username).to eq('paayaw.dev')
      end
    end
  end

  describe 'scopes and instance methods'
end
