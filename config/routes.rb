require 'sidekiq/web'

SnapbyApp::Application.routes.draw do
  devise_for :users, :skip => [:registrations], :controllers => { passwords:'passwords' } 
  resources :snapbies
  patch  "/users/password" => "passwords#update"
  root :to => "home#index"

  get "/about" => "home#about"
  get "/privacy" => "home#privacy"
  get "/terms" => "home#terms"
  get "/contact" => "home#contact"
  get "/global_feed_snapbies" => "home#global_feed_snapbies"
  get "/obsolete_api" => "snapbies#obsolete_api"

  #Sinatra app to monitor queues provided by sidekiq/web
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v1  do
      resources :users, only: [:create, :update] 
      resources :flags, only: [:create]
      resources :snapbies, only: [:create, :show, :index]
      resources :comments, only: [:create, :index]
      resources :likes, only: [:create, :index, :destroy]
      resources :relationships, only: [:create]
      resources :activities, only: [:index]
      devise_for :users, :skip => [:registrations], :controllers => { sessions:'api/v1/sessions', passwords:'api/v1/passwords' } # custom controller for API token access with devise

      get "/obsolete_api" => "api#obsolete_api"
      get "/bound_box_snapbies" => "snapbies#bound_box_snapbies"
      post "users/facebook_create_or_update" => "users#facebook_create_or_update"
      get  "/get_snapby_meta_data" => "snapbies#get_snapby_meta_data"
      patch "/modify_user_credentials" => "users#modify_user_credentials" #deprecated
      put "/modify_user_credentials" => "users#modify_user_credentials" #deprecated
      get  "/user_likes" => "likes#user_likes"
      put  "snapbies/remove" => "snapbies#remove"
      patch  "snapbies/remove" => "snapbies#remove"
      put  "snapbies/trending" => "snapbies#trending"
      patch  "snapbies/trending" => "snapbies#trending"
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
      get "snapbies/local_snapbies" => "snapbies#local_snapbies"
      get "local_snapbies_count" => "snapbies#local_snapbies_count"
    end
  end
end
	