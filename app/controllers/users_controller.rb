class UsersController < ApplicationController
  before_action :set_user,   only: [:show]

  def show
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 20 )
  end

  def questions
    @user = User.find(params[:id])
    @questions = @user.questions.paginate(page: params[:page], per_page: 10 )
  end

  def answers
    @user = User.find(params[:id])
    @answers = @user.answers.paginate(page: params[:page], per_page: 10 )
  end

########################################################################3

  private

    def set_user
      @user = User.find(params[:id])
    end

end
