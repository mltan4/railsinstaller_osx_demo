def full_title(page_title)
  base_title = "BestBay"
  if page_title.empty?
    base_title
  else
    "#{base_title} | #{page_title}"
  end
end

def create_new_item
  visit new_item_path
  fill_in "Display title", with: "capybara_test_item"
  click_button "Update Item"
end

def sign_in(user)
  visit new_user_session_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  #Sign in when not using Capybara as well.
  cookies[:remember_me] = user.remember_me
end