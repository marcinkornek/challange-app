class AcceptAnswersController < ApplicationController
  def new
  end

  def create
    user = User.find_by_email(params[:email])

  end

end
