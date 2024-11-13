# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy
  validates :title, :author, :publication_year, :isbn, presence: true
  validates :isbn, format: { with: /\A\d{10}(\d{3})?\z/, message: 'must be a valid ISBN' }


  def average_rating
    reviews.average(:rating).to_f
  end
end
