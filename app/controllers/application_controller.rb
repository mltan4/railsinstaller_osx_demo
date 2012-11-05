# ==Controller for the Application:
#
# This is a protect_from_forgery feature built in Rails that protects against Cross-Site Request Forgery (CSRF) attacks.
class ApplicationController < ActionController::Base
  protect_from_forgery
end
