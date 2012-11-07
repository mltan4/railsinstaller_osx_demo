# ==Controller for Welcome Page:
# Has index action to set the order for displaying the categories on the welcome page.
#

class WelcomeController < ApplicationController

  # Index action for WelcomeController.
  #
  # This section sets the order for categories display.

def index
    @categories = Category.order("id ASC")
    @page_title = "Home"
  end
end
