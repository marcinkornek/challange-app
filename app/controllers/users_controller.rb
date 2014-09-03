class UsersController < ApplicationController
  before_action :set_user,   only: [:show]

  def show
  end

  def index
    @users = User.paginate(page: params[:page], per_page: 20 )
  end

########################################################################3

  private

    def set_user
      @user = User.find(params[:id])
    end

end
