# Controller for Welcome Page
#
# Has index action
class WelcomeController < ApplicationController
  def index
    #Set order for categories display
    @categories = Category.order("id ASC")
  end
end
