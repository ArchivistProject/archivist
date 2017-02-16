Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :documents, only: [:index, :show] do
    member do
      get :description, to: 'documents#show_description'
      put :description, to: 'documents#update_description'

      get :tags, to: 'documents#show_tags'
      put :tags, to: 'documents#update_tags'
    end
  end

  resources :metadata_fields, only: [:update] do
    collection do
      get :types
    end
  end

  namespace :public do
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
  end
end
