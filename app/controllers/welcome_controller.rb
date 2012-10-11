class WelcomeController < ApplicationController
  def index
    @categories = Category.order("id ASC")
  end
end
