class WelcomeController < ApplicationController
  def index
    #Set order for categories display
    @categories = Category.order("id ASC")
    @page_title = "Home"
  end
end
