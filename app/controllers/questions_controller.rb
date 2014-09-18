class QuestionsController < ApplicationController
  before_action :authenticate_user!,  except: [:show, :index]
  before_action :question,            only:   [:show, :edit, :update, :destroy, :accept_answer]
  before_action :correct_user,        only:   [:update, :destroy]

  def index
    @questions = Question.paginate(page: params[:page], per_page: 10 )
  end

  def show
    @answer = Answer.new
    respond_to do |format|
      format.html # renders show.html.erb
      format.js   # renders show.js.erb
    end
  end

  def new
    @title = "New question"
    @question = Question.new
  end

  def edit
    @title = "Edit question"
  end

  def create
    # @question = Question.new(question_params)
    # @question.user = current_user
    # @question.decrement_points(10)
    # @question = Question.create(question_params)
    @question = QuestionCreator.new.create(question_params)
    if @question.persisted?
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end

  end

  def update
    if question_params[:accepted_answer_id].nil?
      if question.update(question_params)
        redirect_to question, notice: 'Question was successfully updated.'
      else
        render :edit
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
      redirect_to question, notice: 'Answer was accepted.'
      UserMailer.accept_answer(accepted_answer).deliver
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
      format.js { render :update }
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
      format.js { render :update }
    end
  end

  def destroy
    question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end


################################################################################

  private
    # Use callbacks to share common setup or constraints between actions.
    def question
      @question ||= Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :contents, :accepted_answer_id).merge(user: current_user)
    end

    def correct_user
      unless current_user?(question.user)
        redirect_to root_url
      end
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

end
