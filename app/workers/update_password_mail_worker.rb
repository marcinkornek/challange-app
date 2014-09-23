class UpdatePasswordMailWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(self_id)
    UserMailer.password_changed(self_id).deliver
  end

end
