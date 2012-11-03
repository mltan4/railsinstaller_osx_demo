class UserMailer < ActionMailer::Base
  default :from => "notifications@example.com"


  # @param [User] user
  # 
  # @return [mail]
  def welcome_email(user)
    @user = user
    @url  = "http://example.com/login"
    mail(:to => @user.email, :subject => "Welcome to My Awesome Site")
  end
end