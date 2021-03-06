Rps::Application.routes.draw do
  root to: 'users#index'

  post "users/create"   => "users#create",  as: :create_user

  get  "scores/:iidxid" => "scores#show",   as: :show_scores
  post "scores/update"  => "scores#update", as: :scores_update

  get  "powers/update/:iidxid"  => "powers#update", as: :update_powers

  get  "musics"         => "musics#index",  as: :musics
  post "musics/update"  => "musics#update", as: :update_musics

  # temp
  get "debug" => "musics#update"
  get "powers/update_all" => "powers#update_all"
  get "scores/update_all_rate" => "scores#update_all_rate"
end
