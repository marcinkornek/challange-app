# Supported options: :resque, :sidekiq, :delayed_job, :queue_classic, :torquebox, :backburner
if Rails.env.development?
  Devise::Async.backend = :sidekiq
  Devise::Async.queue   = :default
end
# Devise::Async.enabled = true
