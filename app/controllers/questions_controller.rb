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

    elsif question.accepted_answer_id.nil?
      question.update(question_params)
      user = Answer.find(question.accepted_answer_id).user # question.accepted_answer.user  -doesn't work
      increment_points(user)
      redirect_to question, notice: 'Answer was accepted.'
    elsif question.accepted_answer_id
      user_old = Answer.find(question.accepted_answer_id).user # question.accepted_answer.user  -doesn't work
      decrement_points(user_old)
      question.update(question_params)
      user = Answer.find(question.accepted_answer_id).user # question.accepted_answer.user  -doesn't work
      increment_points(user)
      # p '----------------'
      # p user
      # p '----------------'

      redirect_to question, notice: 'Answer was accepted.'

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

    def increment_points(user)
      user.points += 25
      user.save
    end

    def decrement_points(user)
      user.points -= 25
      user.save
    end
end
