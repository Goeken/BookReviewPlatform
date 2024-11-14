# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_book, only: %i[show edit update destroy]
  before_action :authorize_book!, only: %i[edit update destroy]

  def index
    @books = Book.with_average_rating
                  .search(params[:search])
                  .sorted(params[:sort], params[:direction])
                  .page(params[:page]).per(10)
  end

  def show
    @reviews = @book.reviews.includes(:user).where.not(user_id: nil)
    @review_form = current_user && !@book.reviews.exists?(user: current_user) ? @book.reviews.new : nil
  end

  def new
    @book = current_user.books.new
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to @book, notice: 'Book successfully created'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book successfully updated'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to current_user, notice: 'Book successfully deleted'
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id])
    return if @book.present?

    redirect_to books_path, alert: 'Book not found'
  end

  def book_params
    params.require(:book).permit(:title, :author, :publication_year, :isbn)
  end

  def safe_order_clause(sort_field, sort_direction)
    if %w[title author].include?(sort_field)
      "LOWER(#{sort_field}) #{sort_direction}"
    else
      "#{sort_field} #{sort_direction}"
    end
  end

  def authorize_book!
    return if @book.user == current_user

      redirect_to books_path, alert: 'You are not authorized to perform this action'
  end
end
