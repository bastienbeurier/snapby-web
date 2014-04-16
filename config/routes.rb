require 'sidekiq/web'

SnapbyApp::Application.routes.draw do
  devise_for :users, :skip => [:registrations], :controllers => { passwords:'passwords' } 
  resources :snapbys
  patch  "/users/password" => "passwords#update"
  root :to => "home#index"

  get "/about" => "home#about"
  get "/privacy" => "home#privacy"
  get "/terms" => "home#terms"
  get "/contact" => "home#contact"
  get "/global_feed_snapbys" => "home#global_feed_snapbys"
  get "/obsolete_api" => "snapbys#obsolete_api"

  #Sinatra app to monitor queues provided by sidekiq/web
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v1  do
      resources :users, only: [:create, :update] 
      resources :flags, only: [:create]
      resources :snapbys, only: [:create, :show, :index]
      resources :comments, only: [:create, :index]
      resources :likes, only: [:create, :index, :destroy]
      resources :relationships, only: [:create]
      resources :activities, only: [:index]
      devise_for :users, :skip => [:registrations], :controllers => { sessions:'api/v1/sessions', passwords:'api/v1/passwords' } # custom controller for API token access with devise

      get "/obsolete_api" => "api#obsolete_api"
      get "/bound_box_snapbys" => "snapbys#bound_box_snapbys"
      post "users/facebook_create_or_update" => "users#facebook_create_or_update"
      get  "/get_snapby_meta_data" => "snapbys#get_snapby_meta_data"
      patch "/modify_user_credentials" => "users#modify_user_credentials" #deprecated
      put "/modify_user_credentials" => "users#modify_user_credentials" #deprecated
      get  "/user_likes" => "likes#user_likes"
      put  "snapbys/remove" => "snapbys#remove"
      patch  "snapbys/remove" => "snapbys#remove"
      put  "snapbys/trending" => "snapbys#trending"
      patch  "snapbys/trending" => "snapbys#trending"
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
      get "snapbys/local_snapbys" => "snapbys#local_snapbys"
      get "local_snapbys_count" => "snapbys#local_snapbys_count"
    end
  end
end
	