# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Books', type: :request do
  let(:user) { User.create!(email: 'test@example.com', password: 'password') }
  let!(:book) do
    Book.create!(title: 'Test Book', author: 'Author Name', publication_year: 2023, isbn: '1234567890', user:)
  end

  describe 'GET /index' do
    it 'returns a successful response and includes book titles' do
      get books_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Test Book')
    end
  end

  describe 'POST /create' do
    context 'when the user is signed in' do
      before do
        sign_in user
      end

      it 'creates a new book with valid attributes and redirects to the book show page' do
        post books_path, params: {
          book: {
            title: 'New Book',
            author: 'New Author',
            publication_year: 2022,
            isbn: '0987654321'
          }
        }

        expect(response).to redirect_to(book_path(Book.last))
        follow_redirect!

        expect(response.body).to include('New Book')
        expect(Book.last.title).to eq('New Book')
      end
    end
  end

  describe 'PATCH /update' do
    context 'when the user is signed in' do
      before do
        sign_in user
      end

      it 'updates the book and redirects to the show page' do
        patch book_path(book), params: {
          book: {
            title: 'Updated Title'
          }
        }

        expect(response).to redirect_to(book_path(book))
        follow_redirect!

        expect(response.body).to include('Updated Title')
        expect(book.reload.title).to eq('Updated Title')
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign-in page' do
        patch book_path(book), params: {
          book: {
            title: 'Unauthorized Update'
          }
        }

        expect(response).to redirect_to(new_user_session_path)
        expect(book.reload.title).to eq('Test Book')
      end
    end
  end

  describe 'DELETE /destroy' do
    context 'when the user is signed in' do
      before do
        sign_in user
      end

      it 'deletes the book and redirects to the index page' do
        expect do
          delete book_path(book)
        end.to change(Book, :count).by(-1)
      end
    end

    context 'when the user is not signed in' do
      it 'redirects to the sign-in page' do
        expect do
          delete book_path(book)
        end.not_to change(Book, :count)

        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
