# frozen_string_literal: true

class Book < ApplicationRecord
  belongs_to :user
  has_many :reviews, dependent: :destroy

  validates :title, :author, :publication_year, :isbn, presence: true
  validates :isbn, format: { with: /\A\d{10}(\d{3})?\z/, message: 'must be a valid ISBN' }

  scope :with_average_rating, lambda {
                                left_joins(:reviews)
                                  .select('books.*, COALESCE(AVG(reviews.rating), 0) AS average_rating')
                                  .group('books.id')
                              }

  scope :search, lambda { |term|
    where('title ILIKE :search OR author ILIKE :search', search: "%#{term}%") if term.present?
  }

  scope :sorted, lambda { |field, direction|
    order(safe_order_clause(field, direction))
  }

  def self.safe_order_clause(sort_field, sort_direction)
    valid_sort_fields = %w[id title author average_rating]
    sort_field = valid_sort_fields.include?(sort_field) ? sort_field : 'id'

    default_sort_direction = if %w[title author].include?(sort_field)
                               'asc'
                             else
                               'desc'
                             end

    sort_direction = %w[asc desc].include?(sort_direction) ? sort_direction : default_sort_direction

    if %w[title author].include?(sort_field)
      "LOWER(#{sort_field}) #{sort_direction}"
    else
      "#{sort_field} #{sort_direction}"
    end
  end

  def average_rating
    reviews.average(:rating).to_f || 0
  end
end
