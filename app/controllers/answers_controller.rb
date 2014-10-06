class AnswersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_question
  before_action :answer,       only: [:like_answer, :dislike_answer]
  before_action :accepted?,    only: [:create]

  def create
    @answer = Answer.new(answer_params)
    @answer.user = current_user
    @answer.question = @question

    if @answer.save
      notifications(@question.user.id, @answer.id)
      pusher_notification(@question.user.id, @answer.question.id, @answer.user.id)
      if @answer.question.user.send_new_message_email?
        if Rails.env.production? # in free heroku is only 1 worker
          UserMailer.new_answer(@answer).deliver
        else
          NewAnswerMailWorker.perform_async(@answer.id)
        end
      end
    end

    respond_to do |format|
      format.html do
        if @answer.persisted?
          redirect_to question_path(@question), notice: "Answer was successfully created."
        else
          redirect_to question_path(@question), alert: "There was an error when adding answer."
        end
      end
      format.js do
        render :create
      end
    end
  end

  def like_answer
    new_value = 1
    dif = difference(answer, new_value)
    update_or_create(answer, dif, new_value)

    respond_to do |format|
      format.html do
        if dif == 0
          redirect_to question_path(@question, anchor: "answer-#{answer.id}"), notice: "You already like this answer."
        else
          redirect_to question_path(@question, anchor: "answer-#{answer.id}"), notice: "You like this answer."
        end
      end
      format.js { render :update }
    end
  end

  def dislike_answer
    new_value = -1
    dif = difference(answer, new_value)
    update_or_create(answer, dif, new_value)

    respond_to do |format|
      format.html do
        if dif == 0
          redirect_to question_path(@question, anchor: "answer-#{answer.id}"), notice: "You already dislike this answer."
        else
          redirect_to question_path(@question, anchor: "answer-#{answer.id}"), notice: "You dislike this answer."
        end
      end
      format.js { render :update }
    end
  end


#######################################################################################

  private

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

  def notifications(question_user_id, new_answer_id)
    user = User.find(question_user_id)
    answer = Answer.find(new_answer_id)
    question = answer.question
    user.notifications.create(answer_id: answer.id, question_id: question.id, notification: 'new_answer')
  end

  def pusher_notification(question_user_id, question_id, new_answer_user_id)
    @new_answer_user = User.find(new_answer_user_id)
    @question = Question.find(question_id)
    @question_user = User.find(question_user_id)
    @last_notification = @question_user.notifications.last
    Pusher["private-user-#{@question_user.id}"].trigger('notification',
                     {'message' =>
                      I18n.t("notifications.#{@last_notification.notification}",
                      user: @new_answer_user.username,
                      question: @question.title)
                     })

  end

  # before actions

  def answer
    @answer ||= Answer.find(params[:id])
  end

  def set_question
    @question = Question.find(params[:question_id])
  end

  def accepted?
    @question = Question.find(params[:question_id])
    if @question.accepted_answer_id
      redirect_to question_path(@question) #, notice: "This question has already accepted answer - you can't add another answer."
    end
  end

end
