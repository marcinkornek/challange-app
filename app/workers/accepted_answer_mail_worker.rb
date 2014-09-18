class AcceptedAnswerMailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(accepted_answer_id)
    accepted_answer = Answer.find(accepted_answer_id)
    UserMailer.accept_answer(accepted_answer).deliver
  end

end
