Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :v10 do
    scope module: 'account' do
      post 'login', to: 'sessions#create', as: :login
      post 'logout', to: 'sessions#destroy', as: :logout
      post 'register', to: 'accounts#create', as: :register
    end

    namespace :account do
      resource :reset_password, only: [:create]
      resource :v_codes, only: [:create]
      resource :verify_vcode, only: [:create]
      resources :users, only: [] do
        resource :profile, only: [:show, :update]
        resource :change_password, only: [:create]
        resources :address
        resources :certification, only: [:index, :create]
      end
    end

    scope module: 'races' do
      resources :u, only:[] do
        resources :races, only: [:index]
        get 'recent_races', to: 'recent_races#index', as: :recent_races
        get 'races/:id/detail', to: 'races#show', as: :race_detail
        get 'races/search_by_keyword', to:'search_by_keyword#index', as: :search_by_keyword
        get 'races/search_range_list', to:'search_range_list#index', as: :search_range_list
      end
      resources :races, only: [] do
        get 'ticket_status', to: 'ticket_status#show', as: :ticket_status
        get 'new_order', to: 'orders#new_order', as: :new_order
        resource :orders, only: [:create]
        resources :sub_races, only: [:index, :show]
        resources :race_ranks, only: [:index]
      end
      resources :race_tickets, only: [:index]
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

    scope module: 'orders' do
      resources :users, only: [] do
        resources :orders, only: [:index, :show] do
          resources :cancel, only: [:create]
        end
      end
    end

    namespace :uploaders do
      resources :avatar, only:[:create]
      resources :card_image, only:[:create]
    end

    scope module: 'players' do
      resources :players, only: [:show]
    end

    namespace :news do
      resources :types, only: [:index, :show]
      resources :search, only: [:index]
    end

    resources :race_hosts, only:[:index]
  end

  unless Rails.env.production?
    namespace :factory do
      get '/clear', to: 'application#clear'
      get '/:ac', to: 'application#create'
    end
  end
end
