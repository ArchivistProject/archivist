Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # list of documents
  #   metadata fields only
  # private upload endpoint

  root to: 'documents#index'

  resources :documents, only: [:index, :show]

  namespace :public do
    resources :documents, only: [:create]
  end
end
