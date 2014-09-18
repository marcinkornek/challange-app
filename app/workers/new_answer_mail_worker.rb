class NewAnswerMailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(new_answer_id)
    new_answer = Answer.find(new_answer_id)
    UserMailer.new_answer(new_answer).deliver
  end

end
