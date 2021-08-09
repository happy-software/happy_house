Rails.application.routes.draw do
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

  resources :users,               except: [:index, :destroy] do
    resources :properties,          only: [:new, :create, :edit, :update, :index, :show] do
      # expense reports
      get  '/expense_reports/',       to: 'expense_reports#index',    as: 'new_expense_report'
      get  '/expense_reports/create', to: 'expense_reports#create',   as: 'create_expense_report'
      get  '/mortgage_expenses/',     to: 'mortgage_expenses#index',  as: 'new_mortgage_expense'
      post '/mortgage_expenses/',     to: 'mortgage_expenses#create', as: 'create_yearly_mortgage_expense'
      get  '/hoa_expenses/',          to: 'hoa_expenses#index',       as: 'new_hoa_expense'
      post '/hoa_expenses/',          to: 'hoa_expenses#create',      as: 'create_yearly_hoa_expense'

      # property documents
      patch '/upload_files',          to: 'properties#upload_files',  as: 'upload_property_documents'

      resources :expense_items
      resources :leases do
        get '/renew', to: 'leases#renew', as: 'renew_current_lease'
      end
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
end
