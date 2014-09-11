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
      UserMailer.new_answer(@answer).deliver
    else
      redirect_to question_path(@question), alert: "There was an error when adding answer."
    end
  end

  def like_answer
    new_value = 1
    dif = difference(answer, new_value)
    update_or_create(answer, dif, new_value)

    if dif == 0
      redirect_to question_path(@question, anchor: "answer-#{answer.id}"), notice: "You already like this answer."
    else
      redirect_to question_path(@question, anchor: "answer-#{answer.id}"), notice: "You like this answer."
    end
  end

  def dislike_answer
    new_value = -1
    dif = difference(answer, new_value)
    update_or_create(answer, dif, new_value)

    if dif == 0
      redirect_to question_path(@question, anchor: "answer-#{answer.id}"), notice: "You already dislike this answer."
    else
      redirect_to question_path(@question, anchor: "answer-#{answer.id}"), notice: "You dislike this answer."
    end
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

    def change_points(answer, points)
      answer.points += points
      answer.save
      answer.user.points += 5*points
      answer.user.save
    end

    def difference(answer, new_value)
      old = answer.opinions.find_by(user_id: current_user.id).try(:opinion) || 0
      new_value - old
    end

    def update_or_create(answer, dif, new_value)
      change_points(answer, dif)
      status = answer.opinions.find_by(user_id: current_user.id)
      if status.nil?
        answer.opinions.create(opinion: new_value, user_id: current_user.id)
      else
        status.update_attributes(opinion: new_value)
      end
    end

end
