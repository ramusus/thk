Project::Application.routes.draw do

  match '/championships/archive/' => 'championships#archive', :as => "championships_archive"
  resources :championships
  resources :teams

  resources :articles
  devise_for :users

  mount Ckeditor::Engine => '/ckeditor'
  mount RailsAdmin::Engine => '/admin', :as => 'rails_admin'

  root :to => "application#index"
  match 'thk' => 'teams#thk', :as => "thk"
  match 'mhk' => 'teams#mhk', :as => "mhk"

  Articletype.where("slug != ''").each do |type|
    match type.slug => "articles#articles_by_type", :as => type.slug, :slug => type.slug
  end
  match 'articles_mhl' => 'articles#articles_mhl', :as => "articles_mhl"

  match "/:slug/" => "pages#show"

end