# frozen_string_literal: true

class ReviewsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_book
  before_action :set_review, only: %i[edit update destroy]
  before_action :authorize_review!, only: %i[edit update destroy]

  def create
    @review = @book.reviews.find_or_initialize_by(user: current_user)

    if @review.update(review_params)
      respond_to do |format|
        format.turbo_stream
        format.html { redirect_to book_path(@book), notice: 'Review successfully created!' }
      end
    else
      respond_to do |format|
        format.turbo_stream do
          render turbo_stream: turbo_stream.replace('review_form', partial: 'reviews/review_form',
                                                                   locals: { book: @book, review_form: @review })
        end
        format.html { render 'books/show', status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @review.destroy
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to book_path(@book), notice: 'Review successfully deleted' }
    end
  end

  def edit; end

  def update
    if @review.update(review_params)
      redirect_to book_path(@review.book), notice: 'Review updated successfully'
    else
      render :edit, status: :unprocessable_entity
    end
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

  def authorize_review!
    return if @review.user == current_user

    redirect_to book_path(@review.book), alert: 'You are not authorized to perform this action'
  end
end
