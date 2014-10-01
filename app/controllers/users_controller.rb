class UsersController < ApplicationController
  before_action :set_user,   only: [:show, :questions, :answers]

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


  def sort_column
    # params[:sort] || 'username'
    User.column_names.include?(params[:sort]) ? params[:sort] : 'username'
  end

  def sort_direction
    # params[:direction] || 'asc'
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'asc'
  end

  # before actions

  def set_user
    @user = User.find(params[:id])
  end

end
