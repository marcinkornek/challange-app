class QuestionCreator

  def create(question_params)
    # @user = current_user
    # p '----------------------'
    # p question_params
    # p '----------------------'
    current_user = question_params[:user]
    question = Question.new(question_params)
    # puts question.user.points
    unless validate_points(current_user, question)
      decrement_points(current_user)
      question.save
    end
    question


  end

  ######################################################

  private

    # def question_params
    #   params.require(:question).permit(:title, :contents, :accepted_answer_id).merge(user: current_user)
    # end

    def validate_points(user, question)
      if user.points < 10
        question.errors.add(:base, "You don't have enough points to create new question")
        # render :new
        # notice: "You don't have enough points to create new question."
      end
    end

    def decrement_points(user)
      user.points -= 10
    end

end
