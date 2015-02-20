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
   
end
