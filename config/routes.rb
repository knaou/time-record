Rails.application.routes.draw do
  resources :time_entries do
    collection do
      get :entries_by
      post :add_time
      post :delete_time
    end
  end
  resources :types
  resources :days

  root 'home#index'

  get 'home/index'
  get 'home/input'
  get 'home/other'
end
