Icebox::Application.routes.draw do
  # The priority is based upon order of creation:
  # first created -> highest priority.
  resources :cruises do 
    resources :observations do
      collection do
        post :import
      end
    end
    collection do 
      get :import
    end
    member do
      get :graph
      get :photo
    end
  end
  
  resources :users do
    resources :uploaded_observations
  end
  resources :photos, only: [:edit, :update]

  resource :chart, only: :show
  resource :map, only: :show

  namespace :admin do
    resource :dashboard, only: :show
    resources :observations, except: :new do
      member do
        post :accept
        post :reject
      end
    end
    resources :imports
    resources :cruises do
      member do
        post :approve #Approve cruise
        post :accept_observations 
        post :reject_observations
      end
    end
    resources :uploaded_observations
    resources :users do
      collection do
        post :toggle_environment
      end
    end
    resources :lookups
    resources :photos, only: [:create, :destroy]
  end
  
  
  namespace :api do 
    resources :cruises, only: [:index, :show] do
      resources :observations, only: [:index, :show]
      collection do 
        get :all
      end
    end
    resources :lookups, only: [:index, :show]
  end
  
  resource :pages, only: [] do 
    collection do
      get 'about'
    end
  end
  
  require "admin_constraint"
  require 'sidekiq/web'
  mount Sidekiq::Web => '/admin/jobs', :constraints => AdminConstraint.new
  
  match '/admin/users/:id/approve/:value', to: 'admin/users#approve', as: 'approve_user'
  match '/admin/cruises/:id/approve/:value', to: 'admin/cruises#approve', as: 'approve_cruise'
  match '/auth/:provider/callback', to: 'sessions#create'
  match '/auth/failure' => 'sessions#failure'
  match '/login' => 'sessions#new', as: 'login'
  match '/logout' => 'sessions#destroy', as: 'logout'



  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'cruises#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
