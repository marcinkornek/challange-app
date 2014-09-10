class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :answer,       only:   [:update]

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

  def update
    if params[:answer][:like] == 'like'
      new_value = 1
      dif = difference(answer, new_value)
      p '-----------------'
      p dif
      p answer.id
      p '-----------------'
      increment_points(answer, dif)
      if dif == 1
        answer.create_opinion(opinion: new_value, user_id: current_user.id)
        redirect_to question_path(@question), notice: "You like this answer."
      elsif dif == 2
        answer.opinion.opinion = new_value
        answer.opinion.save
        redirect_to question_path(@question), notice: "You like this answer."
      else
        redirect_to question_path(@question), notice: "You already like this answer."
      end
    elsif params[:answer][:like] == 'dislike'
      new_value = -1
      dif = difference(answer, new_value)
      p '-----------------'
      p dif
      p answer.id
      p '-----------------'
      increment_points(answer, dif)
      if dif == -1
        answer.create_opinion(opinion: new_value, user_id: current_user.id)
        redirect_to question_path(@question), notice: "You don't like this answer."
      elsif dif == -2
        answer.opinion.opinion = new_value
        answer.opinion.save
        redirect_to question_path(@question), notice: "You don't like this answer."
      else
        redirect_to question_path(@question), notice: "You already don't like this answer."
      end
    end
      # Opinion.find_or_initialize_by(opinion: new_value, user_id: current_user.id)
      # p '------------------'
      # p dif
      # p answer.opinion.try(:opinion)
      # p '------------------'

      # if answer.opinion.nil?
      #   # answer.find_or_initialize
      #   # new = 1
      #   # diference(answer,new)
      #   answer.create_opinion(opinion: 1, user_id: current_user.id)
      #   increment_points(answer)
      #   answer.update(answer_params)
      #   redirect_to question_path(@question), notice: "You like this answer."
      # elsif answer.opinion.opinion == -1
      #   2.times  {increment_points(answer)}
      #   answer.opinion.opinion = 1
      #   answer.opinion.save
      #   answer.update(answer_params)
      #   redirect_to question_path(@question), notice: "You like this answer."
      # else
      #   redirect_to question_path(@question), notice: "You already like this answer."
      # end
    # elsif params[:answer][:like] == 'dislike'
    #   if answer.opinion.nil?
    #     answer.create_opinion(opinion: -1, user_id: current_user.id)
    #     decrement_points(answer)
    #     answer.update(answer_params)
    #     redirect_to question_path(@question), notice: "You don't like this answer."
    #   elsif answer.opinion.opinion == 1
    #     2.times  {decrement_points(answer)}
    #     answer.opinion.opinion = -1
    #     answer.opinion.save
    #     answer.update(answer_params)
    #     redirect_to question_path(@question), notice: "You don't like this answer."
    #   else
    #     redirect_to question_path(@question), notice: "You already don't like this answer."
    #   end
    # end
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

     def decrement_points(answer)
      answer.points -= 1
      answer.save
      answer.user.points -= 5
      answer.user.save
    end

    def difference(answer, new_value)
      old = answer.opinion.try(:opinion) || 0
      new_value - old
    end
end
