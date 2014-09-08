class QuestionsController < ApplicationController
  before_action :authenticate_user!,  except: [:show, :index]
  before_action :question,        only:   [:show, :edit, :update, :destroy, :accept_answer]
  before_action :correct_user,        only:   [:update, :destroy]

  def index
    @questions = Question.paginate(page: params[:page], per_page: 10 )
  end

  def show
    @answer = Answer.new
  end

  def new
    @question = Question.new
  end

  def edit
  end

  def create
    @question = Question.new(question_params)
    @question.user = current_user

    if @question.save
      redirect_to @question, notice: 'Question was successfully created.'
    else
      render :new
    end
  end

  def update
    if question.update(question_params)
      redirect_to question, notice: 'Question was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    question.destroy
    redirect_to questions_url, notice: 'Question was successfully destroyed.'
  end

  def accept_answer
    @question.accepted_answer(answer)
  end

################################################################################

  private
    # Use callbacks to share common setup or constraints between actions.
    def question
      @question ||= Question.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def question_params
      params.require(:question).permit(:title, :contents, :accepted_answer_id)
    end

    def correct_user
      unless current_user?(question.user)
        redirect_to root_url
      end
    end
end
