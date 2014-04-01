#Dependency on redis initializer
Sidekiq.configure_server do |config|
  config.redis = { :url => ENV["REDISTOGO_URL"], namespace: "street-shout-web" }
end

Sidekiq.configure_client do |config|
  config.redis = { :url => ENV["REDISTOGO_URL"], namespace: "street-shout-web" }
end