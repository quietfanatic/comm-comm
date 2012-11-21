CommComm::Application.routes.draw do

  get 'login/entrance'
  post 'login/login'
  get 'login/signup'
  post 'login/journey'
  get 'login/journey'
  post 'login/logout'
  
  get 'main/topic'  # temporary redirect
  get 'main/board'
  get 'main/settings'
  get 'main/update'
  get 'main/backlog'
  get 'main/about'
  get 'main/mail'

  root :to => 'main#board'

  post 'post/new'
  post 'post/button'
  post 'post/mail'
  post 'configure/profile'
  post 'configure/a_session'
  post 'configure/confirm'
  post 'configure/change_board'
  post 'configure/new_board'
  post 'configure/merge_boards'
  post 'configure/undo_last_merge'
  post 'configure/default_boards'
  post 'configure/user'
  post 'configure/mail'
  post 'configure/test_mail'
  post 'configure/updating'

  # The priority is based upon order of creation:
  # first created -> highest priority.

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
