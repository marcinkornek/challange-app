class Users::RegistrationsController < Devise::RegistrationsController
  # def new
  #   super
  # end

  def create
    super

    # if resource.save
    #   if params[:user][:avatar].present?
    #     render 'crop'
  end
end
