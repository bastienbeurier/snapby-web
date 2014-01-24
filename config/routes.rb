StreetShout::Application.routes.draw do
  devise_for :users, :skip => [:registrations], :controllers => { passwords:'passwords' } 
  resources :shouts
  patch  "/users/password" => "passwords#update"
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
      resources :users, only: [:create, :update]
      resources :flags, only: [:create]
      resources :shouts, only: [:create, :show]
      resources :comments, only: [:create, :index]
      resources :likes, only: [:create, :index]
      devise_for :users, :skip => [:registrations], :controllers => { sessions:'api/v2/sessions', passwords:'api/v2/passwords' } # custom controller for API token access with devise

      get "/obsolete_api" => "api#obsolete_api"
      get "/bound_box_shouts" => "shouts#bound_box_shouts"
      post "users/facebook_create_or_update" => "users#facebook_create_or_update"
      get  "/get_shout_meta_data" => "shouts#get_shout_meta_data"
      patch "/modify_user_credentials" => "users#modify_user_credentials"
    end
  end
end
	