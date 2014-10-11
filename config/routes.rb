Rails.application.routes.draw do
  get 'admin/index'
  # get 'admin', to: 'admin#index'
  
  devise_for :users
  devise_for :admins
  
  # resources :doormsgs

  # resources :rooms

  # resources :doors

 

  get 'welcome/index'
  root 'welcome#index'
  devise_scope :user do
    get '/users/sign_in',to: 'devise/sessions#new'
    get '/users/sign_out',to: 'devise/sessions#destroy'
  end
  devise_scope :admins do
    # @request.env["devise.mapping"] = Devise.mappings[:admin] 
    get '/admins/sign_in'
    # get '/admins/sign_out',to: 'devise/sessions#destroy'
    # delete '/admins/sign_out' => 'devise/sessions#destroy'
    get '/admins/sign_out' => 'admins/sessions#destroy'
  end
  scope :admin do
#     # Directs /admin/products/* to Admin::ProductsController
#     # (app/controllers/admin/products_controller.rb)
#     resources :products
    resources :locations do
      resources :doors, only: [:new, :show, :edit, :create, :update, :destroy] do
        resources :doormsgs, only: [:index, :show, :destroy]
      end
      resources :rooms, only: [:new,:show, :edit, :create, :update, :destroy]
      resources :alerts, only: [:index,:new,:show, :edit, :create, :update, :destroy]
    end
     resources :users
     resources :admins
  end
  resources :locations, only: [ :index, :show] do
    collection do
      get 'fav'
      get 'pop'
      get 'hot'
      get 'cool'
    end
  end

  scope "/api", defaults: {format: :json} do
    resources :doormsgs, only: [:index, :create, :show]
    resources :user_location_favs, only: [:index, :new, :create, :show, :destroy]
    resources :alerts, only: [:index, :show, :destroy]
  end
    # , format: true
  # resources :todos
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
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

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
