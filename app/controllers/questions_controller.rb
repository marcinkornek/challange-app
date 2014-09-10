class QuestionsController < ApplicationController
  before_action :authenticate_user!,  except: [:show, :index]
  before_action :question,            only:   [:show, :edit, :update, :destroy, :accept_answer]
  before_action :correct_user,        only:   [:update, :destroy]

  def index
    @questions = Question.paginate(page: params[:page], per_page: 10 )
  end

  def show
    @answer = Answer.new
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
        user = Answer.find(question.accepted_answer_id).user # question.accepted_answer.user  -doesn't work
        decrement_points(user)
      end
      question.update(question_params)
      user = Answer.find(question.accepted_answer_id).user # question.accepted_answer.user  -doesn't work
      increment_points_user(user)
      redirect_to question, notice: 'Answer was accepted.'
    end
  end

  def destroy
    question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  def like_question
    new_value = 1
    dif = difference(question, new_value)
    increment_points(question, dif)
    if dif == 1
      question.opinions.create(opinion: new_value, user_id: current_user.id)
      redirect_to question_path(@question), notice: "You like this question."
    elsif dif == 2
      question.opinions.find_by(user_id: current_user.id).update_attributes(opinion: new_value)
      redirect_to question_path(@question), notice: "You like this question."
    else
      redirect_to question_path(@question), notice: "You already like this question."
    end
    p '-----------------'
    p dif
    p question.opinions.find_by(user_id: current_user.id)
    p '-----------------'
  end

  def dislike_question
    new_value = -1
    dif = difference(question, new_value)
    increment_points(question, dif)
    if dif == -1
      question.opinions.create(opinion: new_value, user_id: current_user.id)
      redirect_to question_path(@question), notice: "You don't like this question."
    elsif dif == -2
      question.opinions.find_by(user_id: current_user.id).update_attributes(opinion: new_value)
      redirect_to question_path(@question), notice: "You don't like this question."
    else
      redirect_to question_path(@question), notice: "You already don't like this question."
    end
    p '-----------------'
    p dif
    p question.opinions.find_by(user_id: current_user.id)
    p '-----------------'
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

    def increment_points_user(user)
      user.points += 25
      user.save
    end

    def decrement_points(user)
      user.points -= 25
      user.save
    end

    def increment_points(question, points)
      question.points += points
      question.save
      question.user.points += 5*points
      question.user.save
    end

    def difference(question, new_value)
      old = question.opinions.find_by(user_id: current_user.id).try(:opinion) || 0
      new_value - old
    end

end
