class UserMailer < ActionMailer::Base
  default :from => "notifications@example.com"

  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => "craigslist_nathan@me.com", :subject => "Welcome to My Awesome Site")
  end
end