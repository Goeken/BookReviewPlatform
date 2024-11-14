# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book
  before_action :set_review, only: %i[edit update destroy]

  def create
    @review = @book.reviews.find_or_initialize_by(user: current_user)

    if @review.update(review_params)
      redirect_to book_path(@book), notice: 'Review successfully created!'
    else
      flash.now[:alert] = 'Failed to create the review. Please fix the errors'
      render 'books/show'
    end
  end

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to book_path(@book), notice: 'Review successfully updated!'
    else
      flash.now[:alert] = 'Failed to update the review. Please fix the errors'
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to book_path(@book), notice: 'Review successfully deleted'
  end

  private

  def set_book
    @book = Book.find(params[:book_id])
  end

  def set_review
    @review = @book.reviews.find(params[:id])
  end

  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
