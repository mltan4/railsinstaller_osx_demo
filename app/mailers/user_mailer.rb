# ==UserMailer
# Logic that sends an email to user's email address
class UserMailer < ActionMailer::Base
  default :from => "notifications@example.com"

  # Sends an email to user's email address
  # @param [User] user
  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => @user.email, :subject => "Welcome to My Awesome Site")
  end
end