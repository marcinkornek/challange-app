require 'spec_helper'

describe QuestionsController, focus:true do

  before do
    @user = FactoryGirl.create(:user)
    @other_user = FactoryGirl.create(:user)
    @user_question = FactoryGirl.create(:question, user: @user)
    @other_user_question = FactoryGirl.create(:question, user: @other_user)
  end

  before {sign_in @user}

  describe "DELETE #destroy" do
    context "user question" do
      it 'redirects to questions url' do
        delete :destroy, id: @user_question.id
        expect(response).to redirect_to questions_url
      end

      it 'does decrement the Question count' do
        expect { delete :destroy, id: @user_question.id }.to change(Question, :count).by(-1)
      end
    end

    context "other user question" do
      it 'redirects to root url' do
        delete :destroy, id: @other_user_question.id
        expect(response).to redirect_to root_url
      end

      it 'does not decrement the Question count' do
        expect { delete :destroy, id: @other_user_question.id }.to change(Question, :count).by(0)
      end
    end
  end

  describe "PATCH #like_question" do
    context 'for all cases' do
      it 'redirects to questions url' do
        patch :like_question, id: @user_question.id
        expect(response).to redirect_to question_url(@user_question.id)
      end
    end

    context "when question not rated" do
      before do
        @points_before = @user.points
        patch :like_question, id: @user_question.id
      end
      it 'does increment the question points' do
        expect(@user_question.reload.points).to eql(1)
      end
      it 'does increment the user points' do
        expect(@user.reload.points).to eql(@points_before+5)
      end
    end

    context "when question already liked" do
      before do
        @points_before = @user.points
        @user_question.opinions.create(user_id: @user.id, opinion: 1)
        @user_question.update_attributes(points: 1)
        patch :like_question, id: @user_question.id
      end
      it 'does not increment the question points' do
        expect(@user_question.reload.points).to eql(1)
      end
      it 'does not increment the user points' do
        expect(@user.reload.points).to eql(@points_before)
      end
    end

    context "when question already disliked" do
      before do
        @points_before = @user.points
        @user_question.opinions.create(user_id: @user.id, opinion: -1)
        @user_question.update_attributes(points: -1)
        patch :like_question, id: @user_question.id
      end
      it 'does increment the question points' do
        expect(@user_question.reload.points).to eql(1)
      end
      it 'does increment the user points' do
        expect(@user.reload.points).to eql(@points_before+10)
      end
    end
  end

  describe "PATCH #dislike_question" do
    context 'for all cases' do
      it 'redirects to questions url' do
        patch :dislike_question, id: @user_question.id
        expect(response).to redirect_to question_url(@user_question.id)
      end
    end

    context "when question not rated" do
      before do
        @points_before = @user.points
        patch :dislike_question, id: @user_question.id
      end
      it 'does decrement the question points' do
        expect(@user_question.reload.points).to eql(-1)
      end
      it 'does decrement the user points' do
        expect(@user.reload.points).to eql(@points_before-5)
      end
    end

    context "when question already liked" do
      before do
        @points_before = @user.points
        @user_question.opinions.create(user_id: @user.id, opinion: 1)
        @user_question.update_attributes(points: 1)
        patch :dislike_question, id: @user_question.id
      end
      it 'does decrement the question points' do
        expect(@user_question.reload.points).to eql(-1)
      end
      it 'does decrement the user points' do
        expect(@user.reload.points).to eql(@points_before-10)
      end
    end

    context "when question already disliked" do
      before do
        @points_before = @user.points
        @user_question.opinions.create(user_id: @user.id, opinion: -1)
        @user_question.update_attributes(points: -1)
        patch :dislike_question, id: @user_question.id
      end
      it 'does not decrement the question points' do
        expect(@user_question.reload.points).to eql(-1)
      end
      it 'does not decrement the user points' do
        expect(@user.reload.points).to eql(@points_before)
      end
    end
  end

end
