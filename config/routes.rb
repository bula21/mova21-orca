# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', omniauth_callbacks: 'omniauth_callbacks' }

  devise_scope :user do
    get 'login', to: 'sessions#new', as: :new_user_session
    get 'logout', to: 'sessions#destroy', as: :destroy_user_session
  end

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  resources :units, except: [:destroy] do
    resources :participant_units, except: %i[show]
    resource :unit_visitor_day, except: %i[]
    resources :unit_activities, except: %i[new edit] do
      patch :priorize, to: 'unit_activities#priorize', on: :member
      get :stage_commit, to: 'unit_activities#stage_commit', on: :collection
      post :commit, to: 'unit_activities#commit', on: :collection
    end
    post :documents, to: 'units#add_document', as: :documents
    delete 'document/:id', to: 'units#delete_document', as: :document
  end
  resources :leaders, except: [:destroy]
  resources :unit_activity_executions do
    post :import, on: :collection
  end
  resources :activity_executions
  resources :activities do
    resources :delete_activity_executions, only: :index
    delete :delete_activity_executions, to: 'delete_activity_executions#destroy'
    delete :attachment, to: 'activities#delete_attachment', on: :member
    resources :activity_executions do
      post :import, on: :collection
    end
  end

  namespace :admin do
    get '/', to: 'admin#index'
    resources :spots do
      resources :fields
    end
    resources :transport_locations
    resources :activity_categories
    resources :fixed_events, except: %i[show]
    resources :tags
    resources :stufen
  end

  root 'units#index'
end
