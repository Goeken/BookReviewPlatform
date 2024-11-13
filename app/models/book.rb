class Book < ApplicationRecord
  belongs_to :user
  validates :title, :author, :publication_year, :isbn, presence: true
  validates :isbn, format: { with: /\A\d{10}(\d{3})?\z/, message: "must be a valid ISBN" }
end
