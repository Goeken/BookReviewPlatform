# frozen_string_literal: true

class BooksController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]
  before_action :set_book, only: %i[show edit update destroy]

  def index
    @books = Book.where('title ILIKE ? OR author ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
                 .order(id: :desc)
                 .page(params[:page]).per(10)
  end

    def show
      @book = Book.find(params[:id])
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
      render :new
    end
  end

  def edit; end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book successfully updated'
    else
      render :edit, alert: 'Failed to update the book. Please check the errors below.'
    end
  end

  def destroy
    @book.destroy
    redirect_to current_user, notice: 'Book successfully deleted'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :publication_year, :isbn)
  end
end
