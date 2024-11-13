# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { should have_many(:books).dependent(:destroy) }
    it { should have_many(:reviews).dependent(:destroy) }
  end

  describe 'devise modules' do
    it 'is database authenticatable' do
      user = User.new(email: 'test@example.com', password: 'password')
      expect(user.valid_password?('password')).to be_truthy
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(6) }
  end

  describe 'custom behavior' do
    it 'allows creating valid users' do
      user = User.new(email: 'test@example.com', password: 'password', password_confirmation: 'password')
      expect(user).to be_valid
    end

    it 'rejects invalid email format' do
      user = User.new(email: 'invalid-email', password: 'password', password_confirmation: 'password')
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end
  end
end
