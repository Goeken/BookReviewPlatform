require 'rails_helper'

RSpec.describe "Books", type: :request do
  describe "GET /index" do
    it "returns a successful response and includes book titles" do
      user = User.create!(email: 'test@example.com', password: 'password')
      book = Book.create!(title: 'Test Book', author: 'Author Name', publication_year: 2023, isbn: '1234567890', user: user)

      get books_path

      expect(response).to have_http_status(:ok)
      expect(response.body).to include('Test Book')
    end
  end
end
