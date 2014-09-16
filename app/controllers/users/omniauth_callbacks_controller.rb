class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    # p '----------------------------------------'
    # p request.env["omniauth.auth"]
    # p '----------------------------------------'
    @user = User.find_for_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

   def github
    # p '----------------------------------------'
    # p request.env["omniauth.auth"]
    # p '----------------------------------------'
    @user = User.find_for_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "GitHub") if is_navigational_format?
    else
      session["devise.github_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end


  def google_oauth2
    # p '----------------------------------------'
    # puts request.env["omniauth.auth"]
    # p '----------------------------------------'
    @user = User.find_for_oauth(request.env["omniauth.auth"])
    if @user.persisted?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated
      set_flash_message(:notice, :success, :kind => "Gmail") if is_navigational_format?
    else
      session["devise.gmail_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end

