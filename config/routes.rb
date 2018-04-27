Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'listings#index'
  resources :locations, only: :index
  resources :days, only: :index

  get '/scraper', to: 'scraper#scrape'
  get '/scrape_data', to: 'scraper#scrape_data'
  get '/scrape_day', to: 'scraper#scrape_day'
end
