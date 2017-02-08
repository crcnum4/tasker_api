Rails.application.routes.draw do
  resources :devices, only: [:create]
  resources :users, except: [:edit]
  resources :tasks, except: [:show]
  
  get "/login", to: "users#login", as: "user_login"
  get "/req_tok", to: "devices#get_token", as: "get_token"
  get "/new_dev", to: "devices#new_device", as: "new_device"
  get "/check_tkn", to: "devices#check_token", as: "check_token"
  get "/tasks/show", to: "tasks#show", as: "task_show"
  get "/tasks/check", to: "tasks#complete", as: "task_complete"
  get "/update_list", to: "tasks#update_list", as: "task_update_list"
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
