require 'spec_helper'

describe AnswersController do

  before do
    @user = FactoryGirl.create(:user)
    @question = FactoryGirl.create(:question, user: @user)
    @answer = FactoryGirl.create(:answer, question: @question, user: @user)
  end

  before {sign_in @user}

  describe "PATCH #like_answers" do
    context 'for all cases' do
      it 'redirects to questions url with anchor' do
        post :like_answer, question_id: @question.id, id: @answer.id
        expect(response).to redirect_to question_url(@question.id, anchor: "answer-#{@answer.id}")
      end
    end

    context "when answer not rated" do
      before do
        @points_before = @user.points
        post :like_answer, question_id: @question.id, id: @answer.id
      end
      it 'does increment the answer points' do
        expect(@answer.reload.points).to eql(1)
      end
      it 'does increment the user points' do
        expect(@user.reload.points).to eql(@points_before+5)
      end
    end

    context "when answer already liked" do
      before do
        @points_before = @user.points
        @answer.opinions.create(user_id: @user.id, opinion: 1)
        @answer.update_attributes(points: 1)
        post :like_answer, question_id: @question.id, id: @answer.id
      end
      it 'does not increment the answer points' do
        expect(@answer.reload.points).to eql(1)
      end
      it 'does not increment the user points' do
        expect(@user.reload.points).to eql(@points_before)
      end
    end

    context "when answer already disliked" do
      before do
        @points_before = @user.points
        @answer.opinions.create(user_id: @user.id, opinion: -1)
        @answer.update_attributes(points: -1)
        post :like_answer, question_id: @question.id, id: @answer.id
      end
      it 'does increment the answer points' do
        expect(@answer.reload.points).to eql(1)
      end
      it 'does increment the user points' do
        expect(@user.reload.points).to eql(@points_before+10)
      end
    end
  end

  describe "PATCH #dislike_answer" do
    context 'for all cases' do
      it 'redirects to questions url' do
        post :dislike_answer, question_id: @question.id, id: @answer.id
        expect(response).to redirect_to question_url(@question.id, anchor: "answer-#{@answer.id}")
      end
    end

    context "when answer not rated" do
      before do
        @points_before = @user.points
        post :dislike_answer, question_id: @question.id, id: @answer.id
      end
      it 'does decrement the answer points' do
        expect(@answer.reload.points).to eql(-1)
      end
      it 'does decrement the user points' do
        expect(@user.reload.points).to eql(@points_before-5)
      end
    end

    context "when answer already liked" do
      before do
        @points_before = @user.points
        @answer.opinions.create(user_id: @user.id, opinion: 1)
        @answer.update_attributes(points: 1)
        post :dislike_answer, question_id: @question.id, id: @answer.id
      end
      it 'does decrement the answer points' do
        expect(@answer.reload.points).to eql(-1)
      end
      it 'does decrement the user points' do
        expect(@user.reload.points).to eql(@points_before-10)
      end
    end

    context "when answer already disliked" do
      before do
        @points_before = @user.points
        @answer.opinions.create(user_id: @user.id, opinion: -1)
        @answer.update_attributes(points: -1)
        post :dislike_answer, question_id: @question.id, id: @answer.id
      end
      it 'does not decrement the answer points' do
        expect(@answer.reload.points).to eql(-1)
      end
      it 'does not decrement the user points' do
        expect(@user.reload.points).to eql(@points_before)
      end
    end
  end

end
