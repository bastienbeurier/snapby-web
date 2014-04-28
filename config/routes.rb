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
  get "/obsolete_api" => "snapbies#obsolete_api"

  #Sinatra app to monitor queues provided by sidekiq/web
  mount Sidekiq::Web, at: '/sidekiq'

  namespace :api do
    namespace :v1  do
      resources :users, only: [:create, :update] 
      resources :flags, only: [:create]
      resources :snapbies, only: [:create, :show, :index]
      resources :comments, only: [:create, :index]
      resources :likes, only: [:create, :destroy]
      devise_for :users, :skip => [:registrations], :controllers => { sessions:'api/v1/sessions', passwords:'api/v1/passwords' } # custom controller for API token access with devise

      get "/obsolete_api" => "api#obsolete_api"
      get "/bound_box_snapbies" => "snapbies#bound_box_snapbies"
      post "users/facebook_create_or_update" => "users#facebook_create_or_update"
      put  "snapbies/remove" => "snapbies#remove"
      patch  "snapbies/remove" => "snapbies#remove"
      post "likes/delete" => "likes#destroy"
      post "users/get_user_info" => "users#get_user_info"
      get "users/my_likes_and_comments" => "users#my_likes_and_comments"
      post "users/my_likes_and_comments" => "users#my_likes_and_comments"
      get "local_snapbies_count" => "snapbies#local_snapbies_count"
    end
  end
end
	