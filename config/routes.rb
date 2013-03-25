StreetShout::Application.routes.draw do
  resources :shouts
  match "/zone_shouts" => "shouts#zone_shouts"
end
