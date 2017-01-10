Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # list of documents
  #   metadata fields only
  # private upload endpoint

  root to: 'documents#index'

  get 'test', to: 'documents#index'

  resources :documents#, only: [:index, :create, :show, :update, :destroy]

  namespace :public do
    resources :documents#, only: [:create]
  end
end
