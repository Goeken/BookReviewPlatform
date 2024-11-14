# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reviews', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let(:book) do
    Book.create!(title: 'Test Book', author: 'Author Name', publication_year: 2023, isbn: '1234567890', user:)
  end
  let!(:review) { Review.create!(rating: 5, content: 'Great book!', book:, user:) }

  describe 'POST /create' do
    context 'when the user is not signed in' do
      it 'does not create a review and redirects to the sign-in page' do
        expect do
          post book_reviews_path(book), params: {
            review: {
              rating: 4,
              content: 'Unauthorized review'
            }
          }
        end.not_to change(Review, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'PATCH /update' do
    context 'when the user is signed in' do
      before do
        sign_in user
      end

      it 'updates the review with valid attributes' do
        patch book_review_path(book, review), params: {
          review: {
            rating: 3,
            content: 'Decent book'
          }
        }

        review.reload
        expect(review.rating).to eq(3)
        expect(review.content).to eq('Decent book')
      end
    end

    context 'when the user is not signed in' do
      it 'does not update the review and redirects to the sign-in page' do
        patch book_review_path(book, review), params: {
          review: {
            rating: 2,
            content: 'Unauthorized update'
          }
        }

        review.reload
        expect(review.rating).to eq(5)
        expect(review.content).to eq('Great book!')
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when the user is signed in' do
      before do
        sign_in user
      end

      it 'deletes the review' do
        expect do
          delete book_review_path(book, review)
        end.to change(Review, :count).by(-1)

        expect(Review.exists?(review.id)).to be_falsey
      end
    end

    context 'when the user is not signed in' do
      it 'does not delete the review and redirects to the sign-in page' do
        expect do
          delete book_review_path(book, review)
        end.not_to change(Review, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
