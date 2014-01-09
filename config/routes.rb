StreetShout::Application.routes.draw do
  devise_for :users
  resources :shouts

  root :to => "home#index"

  get "/zone_shouts" => "shouts#zone_shout"
  get "/bound_box_shouts" => "shouts#bound_box_shouts"
  get "/global_feed_shouts" => "home#global_feed_shouts"
  get "/demo" => "shouts#demo"

  post "/update_device_info" => "devices#update_device_info"
  post "/flag_shout" => "shouts#flag_shout"

  get "/black_listed_devices" => "devices#black_listed_devices"

  get "/about" => "home#about"
  get "/privacy" => "home#privacy"
  get "/terms" => "home#terms"
  get "/contact" => "home#contact"

  get "/obsolete_api" => "shouts#obsolete_api"

  namespace :api do
    namespace :v2  do
      resources :users, only: [:create]
      resources :flags, only: [:create]
      devise_for :users, :controllers => { sessions:'api/v2/sessions' } # custom controller for API token access with devise
      get "/obsolete_api" => "api#obsolete_api"
      get "/bound_box_shouts" => "shouts#bound_box_shouts"
    end
  end
end
	