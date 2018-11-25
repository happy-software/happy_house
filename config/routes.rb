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

  # expense reports
  get    '/properties/:id/expense_reports/',       to: 'expense_reports#index',  as: 'new_expense_report'
  get    '/properties/:id/expense_reports/create', to: 'expense_reports#create', as: 'create_expense_report'

  resources :users,               except: [:index, :destroy]
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :properties,          only: [:new, :create, :edit, :update, :index, :show] do
    resources :expense_items
  end

  # namespace :api do
  #   namespace :v1 do
  #     resources :properties
  #   end
  # end
end
