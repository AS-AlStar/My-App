Rails.application.routes.draw do
  resources :categories, only: %i[show index]
  root to: 'categories#index'
end
