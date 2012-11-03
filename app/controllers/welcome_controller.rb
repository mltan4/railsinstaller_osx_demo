# ==Controller for Welcome Page:
# Has index action to set the order for displaying the categories on the welcome page
class WelcomeController < ApplicationController

  #Index action for WelcomeController
  def index
    #Set order for categories display
    @categories = Category.order("id ASC")
  end
end
