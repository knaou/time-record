Rails.application.routes.draw do
  resources :time_entries do
    collection do
      get :editable_entries_by
      post :add_time
      post :edit_time
      post :delete_time
    end
  end
  resources :entry_types
  resources :days

  root 'home#index'

  get 'home/index'
  get 'home/input'
  get 'home/other'
  get 'home/download_csv'
  get 'home/download_memo_csv'
end
