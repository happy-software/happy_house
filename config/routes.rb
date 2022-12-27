# frozen_string_literal: true

Rails.application.routes.draw do
  get "password_resets/new"
  get "password_resets/edit"
  root "static_pages#home"

  get    "/help",    to: "static_pages#help"
  get    "/about",   to: "static_pages#about"
  get    "/contact", to: "static_pages#contact"
  get    "/start",   to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"

  resources :users, except: %i[index destroy] do
    resources :properties, only: %i[new create edit update index show] do
      # expense reports
      get  "/mortgage_expenses/",     to: "mortgage_expenses#index",  as: "new_mortgage_expense"
      post "/mortgage_expenses/",     to: "mortgage_expenses#create", as: "create_yearly_mortgage_expense"
      get  "/hoa_expenses/",          to: "hoa_expenses#index",       as: "new_hoa_expense"
      post "/hoa_expenses/",          to: "hoa_expenses#create",      as: "create_yearly_hoa_expense"

      # property documents
      patch "/upload_files",          to: "properties#upload_files",  as: "upload_property_documents"

      resources :expense_items do
        get :report, on: :collection
      end
      resources :leases do
        get "/new_renewal", to: "leases#new_renewal", as: "new_renewal"
        post "/create_renewal", to: "leases#create_renewal", as: "create_renewal"
        member do
          patch "/upload_signed_lease", to: "leases#upload_signed_lease", as: "upload_signed_lease"
        end
      end
      resources :events
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: %i[new create edit update]
end
