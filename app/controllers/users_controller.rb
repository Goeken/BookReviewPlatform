# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :authorize_user!, only: [:show]

  def show
    @books = current_user.books
    @reviews = current_user.reviews
  end

  private

  def authorize_user!
    return if current_user.id.to_s == params[:id]

      redirect_to root_path, alert: 'You are not authorized to view that page'
  end
end
