require 'rails_helper'

RSpec.describe Book, type: :model do
  describe 'associations' do
    it { should belong_to(:user) }
  end

  describe 'validations' do
    it { should validate_presence_of(:title) }
    it { should validate_presence_of(:author) }
    it { should validate_presence_of(:publication_year) }
    it { should validate_presence_of(:isbn) }

    it {
      should allow_value('1234567890').for(:isbn)
    }

    it {
      should allow_value('1234567890123').for(:isbn)
    }

    it {
      should_not allow_value('12345').for(:isbn)
    }

    it {
      should_not allow_value('invalid_isbn').for(:isbn)
    }
  end

  describe 'custom validations' do
    it 'raises an error if ISBN is invalid' do
      book = Book.new(title: 'Test Book', author: 'Author Name', publication_year: 2023, isbn: '12345', user: User.new)
      expect(book).not_to be_valid
      expect(book.errors[:isbn]).to include("must be a valid ISBN")
    end
  end
end
