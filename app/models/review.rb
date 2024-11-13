# frozen_string_literal: true

class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates :rating, inclusion: { in: 1..5 }
  validates :content, presence: true
  validates :user_id, uniqueness: { scope: :book_id, message: 'You can only review a book once.' }
end
