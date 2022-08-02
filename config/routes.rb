# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'sessions', omniauth_callbacks: 'omniauth_callbacks' }

  get 'health/check'
  get 'check_ins/staff', to: 'check_ins#staff'

  devise_scope :user do
    get 'login', to: 'sessions#new', as: :new_user_session
    get 'logout', to: 'sessions#destroy', as: :destroy_user_session
  end

  resources :units, except: [:destroy] do
    resources :participant_units, except: %i[show]
    resource :unit_visitor_day, except: %i[]
    resources :unit_activities, except: %i[new edit] do
      patch :priorize, to: 'unit_activities#priorize', on: :member
      get :stage_commit, to: 'unit_activities#stage_commit', on: :collection
      post :commit, to: 'unit_activities#commit', on: :collection
    end
    get :contact, on: :member
    post :documents, to: 'units#add_document', as: :documents
    post :accept_security_concept, to: 'units#accept_security_concept'
    delete 'document/:id', to: 'units#delete_document', as: :document
    resources :check_ins, only: [:index] do
      put :confirm, on: :member
    end
    resources :check_outs, only: [:index] do
      put :confirm, on: :member
    end
    get :emails, to: 'units#emails', as: :emails, on: :collection
    post :send_sms, to: 'units#send_sms', as: :send_sms, on: :collection
  end
  resource :participant_search, only: %i[show search create]
  resources :leaders, except: [:destroy]
  resources :rover_shifts, only: %i[new create index] do
    patch :update_dependent, on: :collection
  end
  resources :unit_activity_executions do
    post :import, on: :collection
    get :reassign, on: :member, as: :reassign
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
    resources :fixed_events, except: %i[show] do
      delete :attachment, to: 'fixed_events#delete_attachment', on: :member
    end
    resources :tags
    resources :checkpoints, only: %i[index edit update]
    resources :stufen

    resources :checkpoint_units_export, only: %i[index]
    resources :check_ins, only: %i[index show] do
      get :unit_autocomplete, on: :collection
      post :redirect_to_check, on: :member

      resources :check_in_checkpoint_units, only: %i[new create show edit update]
    end

    resources :check_outs, only: %i[index show] do
      get :checkpoint_unit_autocomplete, on: :member
      post :redirect_to_check, on: :member
      resources :check_out_checkpoint_units, only: %i[show edit update]
    end

    resource :participant_search_log, only: [:show]
    resources :unit_contact_logs, only: [:index]
  end

  root 'units#index'
end
