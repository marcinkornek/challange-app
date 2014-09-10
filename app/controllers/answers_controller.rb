class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :answer,       only:   [:like_answer]

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @answer.question = @question
    @answer.user.points

    if @answer.save
      redirect_to question_path(@question), notice: "Answer was successfully created."
    else
      redirect_to question_path(@question), alert: "There was an error when adding answer."
    end
  end

  def like_answer
    new_value = 1
    dif = difference(answer, new_value)
    increment_points(answer, dif)
    if dif == 1
      answer.opinions.create(opinion: new_value, user_id: current_user.id)
      redirect_to question_path(@question), notice: "You like this answer."
    elsif dif == 2
      answer.opinions.find_by(user_id: current_user.id).update_attributes(opinion: new_value)
      redirect_to question_path(@question), notice: "You like this answer."
    else
      redirect_to question_path(@question), notice: "You already like this answer."
    end
    p '-----------------'
    p dif
    p answer.opinions.find_by(user_id: current_user.id)
    p '-----------------'
  end

  def dislike_answer
    new_value = -1
    dif = difference(answer, new_value)
    increment_points(answer, dif)
    if dif == -1
      answer.opinions.create(opinion: new_value, user_id: current_user.id)
      redirect_to question_path(@question), notice: "You don't like this answer."
    elsif dif == -2
      answer.opinions.find_by(user_id: current_user.id).update_attributes(opinion: new_value)
      redirect_to question_path(@question), notice: "You don't like this answer."
    else
      redirect_to question_path(@question), notice: "You already don't like this answer."
    end
    p '-----------------'
    p dif
    p answer.opinions.find_by(user_id: current_user.id)
    p '-----------------'
  end


#######################################################################################

  private

    def answer
      @answer ||= Answer.find(params[:id])
    end

    def set_question
      @question = Question.find(params[:question_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def answer_params
      params.require(:answer).permit(:contents, :points)
    end

    def increment_points(answer, points)
      answer.points += points
      answer.save
      answer.user.points += 5*points
      answer.user.save
    end

    def difference(answer, new_value)
      old = answer.opinions.find_by(user_id: current_user.id).try(:opinion) || 0
      new_value - old
    end
end
