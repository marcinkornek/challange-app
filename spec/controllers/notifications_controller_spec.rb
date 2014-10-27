require 'spec_helper'

describe NotificationsController do

  before do
    @user           = FactoryGirl.create(:confirmed_user)
    @other_user     = FactoryGirl.create(:confirmed_user)
    @user_question  = FactoryGirl.create(:question, user: @user)
  end

  describe "PATCH #update_all" do
    before do
      @other_user_answer        = FactoryGirl.create(:answer, user: @other_user, question: @user_question)
      @other_user_second_answer = FactoryGirl.create(:answer, user: @other_user, question: @user_question)
    end

  end

end
