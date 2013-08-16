Devise::Async.setup do |devise_config|
  devise_config.enabled = true
  devise_config.backend = :delayed_job
  devise_config.queue   = :devise_queue
end
