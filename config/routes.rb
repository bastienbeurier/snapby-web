require 'sidekiq/web'

StreetShout::Application.routes.draw do
  devise_for :users, :skip => [:registrations], :controllers => { passwords:'passwords' } 
  resources :shouts
  patch  "/users/password" => "passwords#update"
  root :to => "home#index"

  get "/about" => "home#about"
  get "/privacy" => "home#privacy"
  get "/terms" => "home#terms"
  get "/contact" => "home#contact"
  get "/global_feed_shouts" => "home#global_feed_shouts"
  get "/obsolete_api" => "shouts#obsolete_api"

  #Sinatra app to monitor queues provided by sidekiq/web
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v2  do
      resources :users, only: [:create, :update] 
      resources :flags, only: [:create]
      resources :shouts, only: [:create, :show]
      resources :comments, only: [:create, :index]
      resources :likes, only: [:create, :index, :destroy]
      resources :relationships, only: [:create]
      resources :activities, only: [:index]
      devise_for :users, :skip => [:registrations], :controllers => { sessions:'api/v2/sessions', passwords:'api/v2/passwords' } # custom controller for API token access with devise

      get "/obsolete_api" => "api#obsolete_api"
      get "/bound_box_shouts" => "shouts#bound_box_shouts"
      post "users/facebook_create_or_update" => "users#facebook_create_or_update"
      get  "/get_shout_meta_data" => "shouts#get_shout_meta_data"
      patch "/modify_user_credentials" => "users#modify_user_credentials" #deprecated
      put "/modify_user_credentials" => "users#modify_user_credentials" #deprecated
      get  "/user_likes" => "likes#user_likes"
      put  "shouts/remove" => "shouts#remove"
      patch  "shouts/remove" => "shouts#remove"
      put  "shouts/trending" => "shouts#trending"
      patch  "shouts/trending" => "shouts#trending"
      post "likes/delete" => "likes#destroy"
      post "relationships/delete" => "relationships#destroy"
      post "users/autofollow" => "users#create_relationships_from_facebook_friends"
      post "users/get_user_info" => "users#get_user_info"
      get "users/suggested_friends" => "users#suggested_friends"
      post "users/suggested_friends" => "users#suggested_friends"
      get "users/followers" => "users#followers"
      post "users/followers" => "users#followers"
      get "users/followed_users" => "users#followed_users"
      post "users/followed_users" => "users#followed_users"
      get "users/my_likes_and_followed_users" => "users#my_likes_and_followed_users"
      post "users/my_likes_and_followed_users" => "users#my_likes_and_followed_users"
      get "activities/unread_activities_count" => "activities#unread_activities_count"
      post "activities/unread_activities_count" => "activities#unread_activities_count"
    end
  end
end
	