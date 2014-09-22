class Users::RegistrationsController < Devise::RegistrationsController
  def new
    super
  end

  def create
    super
  end

  def edit
    super
  end


  def update
    @user = User.find(current_user.id)

    if needs_password?(@user, params)
      successfully_updated = @user.update_with_password(devise_parameter_sanitizer.sanitize(:account_update))
    else
      # remove the virtual current_password attribute
      # update_without_password doesn't know how to ignore it
      params[:user].delete(:current_password)
      successfully_updated = @user.update_without_password(devise_parameter_sanitizer.sanitize(:account_update))
    end

    if successfully_updated
      set_flash_message :notice, :updated
      # Sign in the user bypassing validation in case their password changed
      sign_in @user, :bypass => true
      if params[:user][:avatar].present?
        render 'crop'
      else
        redirect_to after_update_path_for(@user)
      end
    else
      render "edit"
    end
  end

  private

  # check if we need password to update user data
  # ie if password or email was changed
  # extend this as needed
  def needs_password?(user, params)
    (params[:user][:email].present? && user.email != params[:user][:email]) ||
      params[:user][:password].present? ||
      params[:user][:password_confirmation].present?
  end

end
