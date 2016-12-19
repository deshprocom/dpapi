Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  scope :account do
    post 'login', to: 'sessions#create', as: :login
    post 'logout', to: 'sessions#destroy', as: :logout
    post 'register', to: 'accounts#create', as: :register
  end
end
