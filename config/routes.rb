Rails.application.routes.draw do
  root to: 'toppages#index'
  
  get 'login', to: 'sessions#new'
  post 'login', to: 'sessions#create'
  delete 'logout', to: 'sessions#destroy'
  
  get 'signup', to: 'users#new'
  resources :users, only: [:index, :show, :new, :create, :edit, :update]
  
  resources :customers, only: [:index, :show, :new, :create, :edit, :update]
  
  resources :projects, only: [:index, :show, :new, :create, :edit, :update]
  
  resources :orderers, only: [:index, :show, :new, :create, :edit, :update]
  
  resources :companies, only: [:index, :show, :new, :create, :edit, :update]
  
  resources :branches, only: [:index, :show, :new, :create, :edit, :update]
  
  resources :machines, only: [:index, :show, :new, :create]
  
  resources :rental_machines, only: [:index, :show, :new, :create, :edit, :update]
  # resources :rental_machines, only: [:index, :show, :new, :create, :edit, :update] do
  #   collection do
  #     get :reservations
  #     get :uses
  #     get :cominghomes
  #   end
  # end
  
  resources :orders do
    collection do
      get :reservations
      get :uses
      get :cominghomes
    end
  end
  
  resources :storages, only: [:index, :show, :new, :create, :edit, :update]

  
end
