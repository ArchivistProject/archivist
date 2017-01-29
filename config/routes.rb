Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :authentication do
    post :login
    get :status
  end

  resources :documents, only: [:index, :show]

  namespace :public do
    resources :documents, only: [:create]
  end
end
