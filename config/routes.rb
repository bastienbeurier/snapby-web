StreetShout::Application.routes.draw do
  devise_for :users
  devise_for :users, :controllers => {sessions:'sessions'} # custom controller for API token access
  resources :shouts

  root :to => "home#index"

  get "/zone_shouts" => "shouts#zone_shout"
  get "/bound_box_shouts" => "shouts#bound_box_shouts"
  get "/global_feed_shouts" => "shouts#global_feed_shouts"
  get "/demo" => "shouts#demo"

  post "/update_device_info" => "devices#update_device_info"
  post "/flag_shout" => "shouts#flag_shout"

  get "/black_listed_devices" => "devices#black_listed_devices"

  get "/about" => "home#about"
  get "/privacy" => "home#privacy"
  get "/terms" => "home#terms"
  get "/contact" => "home#contact"

  get "/obsolete_api" => "shouts#obsolete_api"
  
end
	