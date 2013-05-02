Rps::Application.routes.draw do
  root to: 'users#index'

  post "users/create"   => "users#create",  as: :create_user

  get  "scores/:iidxid" => "scores#show",   as: :show_scores
  post "scores/update"  => "scores#update", as: :scores_update

  post "powers/update"  => "powers#update", as: :update_powers

  get  "musics"         => "musics#index",  as: :musics
  post "musics/update"  => "musics#update", as: :update_musics

  # temp
  get "debug" => "musics#update"
  get "powers/update_all" => "powers#update_all"
end
