Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v10 do
    scope module: 'account' do
      post 'login', to: 'sessions#create', as: :login
      post 'logout', to: 'sessions#destroy', as: :logout
      post 'register', to: 'accounts#create', as: :register
    end

    namespace :account do
      resource :forward_password, only: [:create]
      resource :vcode, only: [:create]
      resource :verify_vcode, only: [:create]

      resources :users, only: [] do
        resource :profile, only: [:show, :update]
      end
    end

    scope module: 'events' do
      resources :events, param: :node_id, only: [:index, :show]
      post 'events/:node_id/apply', to: 'apply#create', as: :event_apply
      post 'events/search', to: 'search#show', as: :event_search
    end

    scope module: 'users' do
      resources :users, only:[:show] do
        resources :events, only: [:index]
      end
    end
  end
end
