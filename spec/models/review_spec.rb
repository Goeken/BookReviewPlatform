# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:book) }
  end

  describe 'validations' do
    let!(:user) { User.create!(email: 'test@example.com', password: 'password') }
    let!(:book) do
      Book.create!(title: 'Test Book', author: 'Author Name', publication_year: 2023, isbn: '1234567890', user:)
    end
    let!(:existing_review) { described_class.create!(content: 'Great book!', rating: 5, user:, book:) }

    it { should validate_presence_of(:content) }
    it { should validate_inclusion_of(:rating).in_range(1..5) }

    it 'validates uniqueness of user_id scoped to book_id' do
      new_review = described_class.new(content: 'Another review', rating: 4, user:, book:)
      expect(new_review).not_to be_valid
      expect(new_review.errors[:user_id]).to include('You can only review a book once.')
    end
  end

  describe 'custom validations' do
    it 'raises an error if rating is out of range' do
      review = Review.new(content: 'Great book!', rating: 6, user: User.new, book: Book.new)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include('is not included in the list')
    end
  end
end
