class UsersController < ApplicationController
  before_action :set_user,   only: [:show, :questions, :answers]
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def show
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 20 ).order('created_at')
  end

  def questions
    @questions = @user.questions.paginate(page: params[:page], per_page: 10 )
  end

  def answers
    @answers = @user.answers.paginate(page: params[:page], per_page: 10 )
  end

##########################################################################

  private

    def set_user
      @user = User.find(params[:id])
    end

##########################################################################

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password,
        :password_confirmation, :remember_me, :avatar, :avatar_cache) }
      devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password,
        :password_confirmation, :current_password, :avatar, :avatar_cache) }
    end

end
