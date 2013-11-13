StreetShout::Application.routes.draw do
  resources :shouts
  match "/zone_shouts" => "shouts#zone_shouts"
  match "/bound_box_shouts" => "shouts#bound_box_shouts"
  match "/global_feed_shouts" => "shouts#global_feed_shouts"
  match "/demo" => "shouts#demo"

  match "/update_device_info" => "devices#update_device_info"
  match "/flag_shout" => "shouts#flag_shout"

  match "/black_listed_devices" => "devices#black_listed_devices"
end
	