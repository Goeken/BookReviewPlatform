class BooksController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :set_book, only: [:show, :edit, :update, :destroy]

  def index
    @books = Book.where('title ILIKE ? OR author ILIKE ?', "%#{params[:search]}%", "%#{params[:search]}%")
                  .page(params[:page]).per(10)
  end

  def show
    @review = current_user ? @book.reviews.find_or_initialize_by(user: current_user) : nil
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

  def edit
  end

  def update
    if @book.update(book_params)
      redirect_to @book, notice: 'Book successfully updated'
    else
      render :edit
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: 'Book successfully deleted'
  end

  private

  def set_book
    @book = Book.find(params[:id])
  end

  def book_params
    params.require(:book).permit(:title, :author, :publication_year, :isbn)
  end
end
