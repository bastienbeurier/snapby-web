StreetShout::Application.routes.draw do
  resources :shouts

  get "/" => "home#index"

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
end
	