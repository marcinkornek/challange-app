class QuestionCreator

  def create(current_user)
    # @user = current_user
    @user = current_user
    @question = Question.new(user: @user)
    puts @question.user.points
    unless validate_points(@user)
      decrement_points(@user)
      @question.save
      redirect_to question_path, notice: 'Question was successfully created.'
    end



  end

  ######################################################

  private

    def question_params
      params.require(:question).permit(:title, :contents, :accepted_answer_id).merge(user: current_user)
    end

    def validate_points(user)
      if user.points < 10
        # errors.add(:base, "You don't have enough points to create new question")
        # render :new
        notice: "You don't have enough points to create new question."
      end
    end

    def decrement_points(user)
      user.points -= 10
    end

end
