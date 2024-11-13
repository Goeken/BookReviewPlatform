# frozen_string_literal: true

# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


3.times do
  user = User.find_or_create_by!(email: Faker::Internet.unique.email) do |u|
    u.password = 'password'
  end

  5.times do
    book = Book.find_or_create_by!(title: Faker::Book.unique.title, user: user) do |b|
      b.author = Faker::Book.author
      b.publication_year = Faker::Number.between(from: 1900, to: 2023)
      b.isbn = Faker::Number.number(digits: 10)
    end

    3.times do
      Review.find_or_create_by!(user: user, book: book) do |r|
        r.rating = Faker::Number.between(from: 1, to: 5)
        r.content = Faker::Lorem.paragraph
      end
    end
  end
end
