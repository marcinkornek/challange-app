include ApplicationHelper

def sign_in( user, options={} )
  if options[:no_capybara]
    # # Sign in when not using Capybara.
    # remember_token = User.new_remember_token
    # cookies[:remember_token] = remember_token
    # user.update_attribute(:remember_token, User.digest(remember_token))
  else
    visit new_user_session_path
    fill_signin_form(user)
  end
end

def fill_signin_form(user)
  fill_in "Login",    with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

def sign_out
  click_link "Sign out"
end

