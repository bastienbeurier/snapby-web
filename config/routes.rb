StreetShout::Application.routes.draw do
  resources :shouts
  match "/zone_shouts" => "shouts#zone_shouts"
  match "/new_zone_shouts" => "shouts#new_zone_shouts"
  match "/global_feed_shouts" => "shouts#global_feed_shouts"
end
