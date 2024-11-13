# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book

  def create
    @review = @book.reviews.new(review_params.merge(user: current_user))
    if @review.save
      redirect_to @book, notice: 'Review was successfully created.'
    else
      redirect_to @book, alert: @review.errors.full_messages.to_sentence
    end
  end

  def update
    @review = @book.reviews.find(params[:id])
    if @review.update(review_params)
      redirect_to @book, notice: 'Review was successfully updated.'
    else
      redirect_to @book, alert: @review.errors.full_messages.to_sentence
    end
  end

  def destroy
    @review = @book.reviews.find(params[:id])
    @review.destroy
    redirect_to @book, notice: 'Review was successfully deleted.'
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
