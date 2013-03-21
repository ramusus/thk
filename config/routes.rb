Project::Application.routes.draw do
  resources :championships
  resources :teams

  resources :articles
  devise_for :users

  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => "application#index"
  match 'thk' => 'teams#thk', :as => "thk"
  match 'mhk' => 'teams#mhk', :as => "mhk"
  match "/:slug/" => "pages#show"

end