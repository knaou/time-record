Rails.application.routes.draw do
  resources :time_entries
  resources :types
  resources :days

  root 'home#index'

  get 'home/index'
  get 'home/input'
  get 'home/other'
end
