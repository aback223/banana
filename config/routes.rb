Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'listing#index'
  resources :location, only: :index

  get '/scraper', to: 'scraper#scrape', as: 'scrape'
end
