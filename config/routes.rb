Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :authentication do
    post :login
    get :status
  end

  resources :documents, only: [:index, :show, :create, :update] do
    collection do
      post :search, to: 'documents_search#search'
    end

    member do
      get :content, to: 'documents#show_content'
    end

    resources :notes, only: [:create, :update]
  end

  resources :metadata_fields, only: [:update] do
    collection do
      get :types
    end
  end

  namespace :public do
    resources :groups, only: [:index]
    resources :documents, only: [:create]
  end

  namespace :statistics do
    resources :documents, only: [:index, :show] do
      collection do
        get :count
        get :size
      end

      member do
        get :size
      end
    end
  end

  namespace :system do
    resources :groups, only: [:index, :show, :create, :update, :destroy] do
      resources :field, only: [:create, :update, :destroy]
    end
    resources :settings, only: [:index, :update]
  end
end
