class QuestionsController < ApplicationController
  before_action :authenticate_user!,  except: [:show, :index]
  before_action :question,            only:   [:show, :edit, :update, :destroy, :accept_answer]
  before_action :correct_user,        only:   [:update, :destroy]

  def index
    if params[:tag]
      @questions = Question.tagged_with(params[:tag]).paginate(page: params[:page], per_page: 10 )
    else
      @questions = Question.paginate(page: params[:page], per_page: 10 )
    end
  end

  def show
    @answer = Answer.new
    respond_to do |format|
      format.html # renders show.html.erb
      format.js   # renders show.js.erb
    end
  end

  def new
    @title = "Create question"
    @question = Question.new
  end

  def edit
    @title = "Edit question"
  end

  def create
    @title = "Create question"
    @question = QuestionCreator.new.create(question_params)
    if @question.persisted?
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end

  end

  def update # accept_answer
    @title = "Edit question"
    if question_params[:accepted_answer_id]
      @answer = Answer.find(question_params[:accepted_answer_id])
    end
    if question_params[:accepted_answer_id].nil?
      if question.update(question_params)
      else
        return render :edit
      end
    else
      if question.accepted_answer_id
        accepted_answer = Answer.find(question.accepted_answer_id)
        user = accepted_answer.user # question.accepted_answer.user  -doesn't work
        decrement_points(user)
      end
      question.update(question_params)
      accepted_answer = Answer.find(question.accepted_answer_id)
      user = accepted_answer.user # question.accepted_answer.user  -doesn't work
      change_points_user(user)
      notifications(accepted_answer.user.id, accepted_answer.id)
      pusher_notification(accepted_answer.user.id, accepted_answer.id)
      if accepted_answer.user.send_accepted_answer_email?
        if Rails.env.production? # in free heroku is only 1 worker
          UserMailer.accept_answer(accepted_answer).deliver
        else
          AcceptedAnswerMailWorker.perform_async(accepted_answer.id)
        end
      end
    end

    respond_to do |format|
      format.html do
        if @question.persisted?
          redirect_to question, notice: 'Question was successfully updated.'
        else
          redirect_to question, notice: 'Answer was accepted.'
        end
      end
      format.js do
        render :update
      end
    end
  end

  def like_question
    new_value = 1
    dif = difference(question, new_value)
    update_or_create(question, dif, new_value)

    respond_to do |format|
      format.html do
        if dif == 0
          redirect_to question_path(@question), notice: "You already like this question."
        else
          redirect_to question_path(@question), notice: "You like this question."
        end
      end
      format.js { render :change_points }
    end
  end

  def dislike_question
    new_value = -1
    dif = difference(question, new_value)
    update_or_create(question, dif, new_value)

    respond_to do |format|
      format.html do
        if dif == 0
          redirect_to question_path(@question), notice: "You already dislike this question."
        else
          redirect_to question_path(@question), notice: "You dislike this question."
        end
      end
      format.js { render :change_points }
    end
  end

  def destroy
    question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  def tags

  end


################################################################################

  private

  # Never trust parameters from the scary internet, only allow the white list through.
  def question_params
    params.require(:question).permit(:title, :contents, :accepted_answer_id, :tag_list).merge(user: current_user)
  end

  def change_points_user(user)
    user.points += 25
    user.save
  end

  def decrement_points(user)
    user.points -= 25
    user.save
  end

  def change_points(question, points)
    question.points += points
    question.save
    question.user.points += 5*points
    question.user.save
  end

  def difference(question, new_value)
    old = question.opinions.find_by(user_id: current_user.id).try(:opinion) || 0
    new_value - old
  end

  def update_or_create(question, dif, new_value)
    change_points(question, dif)
    status = question.opinions.find_by(user_id: current_user.id)
    if status.nil?
      question.opinions.create(opinion: new_value, user_id: current_user.id)
    else
      status.update_attributes(opinion: new_value)
    end
  end

  def notifications(accepted_answer_user_id, accepted_answer_id)
    user = User.find(accepted_answer_user_id)
    answer = Answer.find(accepted_answer_id)
    question = answer.question
    user.notifications.create(answer_id: answer.id, question_id: question.id, notification: 'accepted_answer')
  end

  def pusher_notification(accepted_answer_user_id, accepted_answer_id)
    @accepted_answer_user = User.find(accepted_answer_user_id)
    @last_notification = @accepted_answer_user.notifications.last
    Pusher["private-user-#{accepted_answer_user_id}"].trigger('notification',
                     {'message' =>
                      I18n.t("notifications.#{@last_notification.notification}",
                      user: Question.find(@last_notification.question_id).user.username,
                      question: Question.find(@last_notification.question_id).title)
                     })

  end

  #before actions

  # Use callbacks to share common setup or constraints between actions.
  def question
    @question ||= Question.find(params[:id])
  end

  def correct_user
    unless current_user?(question.user)
      redirect_to root_url
    end
  end

end
