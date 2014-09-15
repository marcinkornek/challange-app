class UsersController < ApplicationController
  before_action :set_user,   only: [:show, :questions, :answers]
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def show
  end

  helper_method :sort_column, :sort_direction
  def index
    if params[:search]
      @users = User.search(params[:search]).order("created_at DESC").paginate(page: params[:page], per_page: 20 ).order('created_at')
    else
      @users = User.order(sort_column + " " + sort_direction).paginate(page: params[:page], per_page: 20 ).order('created_at')
    end
  end

  def questions
    @questions = @user.questions.paginate(page: params[:page], per_page: 10 )
  end

  def answers
  end

##########################################################################

  private

    def set_user
      @user = User.find(params[:id])
    end

    def sort_column
      # params[:sort] || 'username'
      User.column_names.include?(params[:sort]) ? params[:sort] : 'username'
    end

    def sort_direction
      # params[:direction] || 'asc'
      %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
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
