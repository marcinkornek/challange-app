class UserMailer < ActionMailer::Base
  default from: "no-reply@challangeapp.com"

  def accept_answer(accepted_answer)
    @accepted_answer = accepted_answer
    @question = accepted_answer.question
    @user = @accepted_answer.user
    mail to: @user.email, subject: "Accepted answer"
  end

  def new_answer(answer)
    @answer = answer
    @question = @answer.question
    @user = @answer.question.user
    mail to: @user.email, subject: "New answer"
  end

end
