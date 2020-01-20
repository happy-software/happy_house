Rails.application.routes.draw do
  require 'sidekiq/web'
  require 'sidekiq/cron/web'
  mount Sidekiq::Web => '/sidekiq'

  get 'password_resets/new'
  get 'password_resets/edit'
  root 'static_pages#home'

  get    '/help',    to: 'static_pages#help'
  get    '/about',   to: 'static_pages#about'
  get    '/contact', to: 'static_pages#contact'
  get    '/start',   to: 'users#new'
  get    '/login',   to: 'sessions#new'
  post   '/login',   to: 'sessions#create'
  delete '/logout',  to: 'sessions#destroy'

  # expense reports
  get    '/properties/:id/expense_reports/',       to: 'expense_reports#index',  as: 'new_expense_report'
  get    '/properties/:id/expense_reports/create', to: 'expense_reports#create', as: 'create_expense_report'
  get    '/properties/:id/mortgage_expenses/',     to: 'mortgage_expenses#index', as: 'new_mortgage_expense'
  post   '/properties/:id/mortgage_expenses/',     to: 'mortgage_expenses#create', as: 'create_yearly_mortgage_expense'
  get    '/properties/:id/hoa_expenses/',          to: 'hoa_expenses#index',  as: 'new_hoa_expense'
  post   '/properties/:id/hoa_expenses/',          to: 'hoa_expenses#create', as: 'create_yearly_hoa_expense'

  post '/mms', to: 'mms#process_message'

  # property documents
  patch  'properties/:id/upload_files',            to: 'properties#upload_files', as: 'upload_property_documents'

  resources :users,               except: [:index, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :properties,          only: [:new, :create, :edit, :update, :index, :show] do
    resources :expense_items
    resources :leases do
      get '/renew', to: 'leases#renew', as: 'renew_current_lease'
    end
  end

  # namespace :api do
  #   namespace :v1 do
  #     resources :properties
  #   end
  # end
end
