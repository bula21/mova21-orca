# frozen_string_literal: true

Rails.application.routes.draw do
  resources :transport_locations
  resources :tags
  devise_for :users, controllers: { sessions: 'sessions', omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    get 'login', to: 'sessions#new', as: :new_user_session
    get 'logout', to: 'sessions#destroy', as: :destroy_user_session
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :units, except: [:destroy] do
    resources :participants, except: %i[show destroy]
  end
  resources :leaders, except: [:destroy]
  resources :activities

  root 'pages#index'
end
