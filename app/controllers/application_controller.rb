# ==Controller for the Application:
# protect_from_forgery feature in Rails that protects against Cross-Site Request Forgery (CSRF) attacks.
class ApplicationController < ActionController::Base
  protect_from_forgery
end
