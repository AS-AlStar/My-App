Rails.application.routes.draw do
  resources :posts, except: [:update, :destroy, :edit]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'posts#index'
end


