StreetShout::Application.routes.draw do
  devise_for :users, :skip => [:registrations], :controllers => { passwords:'passwords' } 
  resources :shouts
  patch  "/users/password" => "passwords#update"
  root :to => "home#index"

  get "/about" => "home#about"
  get "/privacy" => "home#privacy"
  get "/terms" => "home#terms"
  get "/contact" => "home#contact"

  get "/obsolete_api" => "shouts#obsolete_api"

  namespace :api do
    namespace :v2  do
      resources :users, only: [:create, :update] do
        member do
          get :followed_users, :followers
        end
      end

      resources :flags, only: [:create]
      resources :shouts, only: [:create, :show]
      resources :comments, only: [:create, :index]
      resources :likes, only: [:create, :index, :destroy]
      resources :relationships, only: [:create]
      devise_for :users, :skip => [:registrations], :controllers => { sessions:'api/v2/sessions', passwords:'api/v2/passwords' } # custom controller for API token access with devise

      get "/obsolete_api" => "api#obsolete_api"
      get "/bound_box_shouts" => "shouts#bound_box_shouts"
      post "users/facebook_create_or_update" => "users#facebook_create_or_update"
      get  "/get_shout_meta_data" => "shouts#get_shout_meta_data"
      patch "/modify_user_credentials" => "users#modify_user_credentials"
      put "/modify_user_credentials" => "users#modify_user_credentials"
      get  "/user_likes" => "likes#user_likes"
      put  "shouts/remove" => "shouts#remove"
      patch  "shouts/remove" => "shouts#remove"
      put  "shouts/trending" => "shouts#trending"
      patch  "shouts/trending" => "shouts#trending"
      post "likes/delete" => "likes#destroy"
      post "relationships/delete" => "relationships#destroy"
      get "users/info" => "users#user_info"
    end
  end
end
	