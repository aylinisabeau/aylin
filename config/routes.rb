Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :categories, except: [:new, :edit, :destroy]
  resources :products, except: [:new, :edit, :destroy]

  post 'login' => 'sessions#login'
end
