Ss::Application.routes.draw do
  resources :products

  resources :todolists

  resources :strategies

  resources :markets

  resources :monitoredmarkets

  resources :plantypefunds

  resources :policyfunds

  resources :strategiesmarkets

  resources :policies

  resources :plantypes

  resources :products

  resources :clients

  resources :currencies

  resources :plantype_strategies

  resources :plantypestrategyfunds

  resources :companies

  # Special Routes for Tables
  match "/meta"                        => "meta#all"
  match "/meta/:id"                    => "meta#show"
  
  
  # Special Routes for Feeders
  match "/feeder/:id"                   => "feeder#show"
  match "/feeder/start/:id"             => "feeder#start"
  match "/feeders/client_update/data"   => "feeder#client_upload"
  match "/feeders/loadfunds/data/"      => "feeder#funds_upload"
  
  # special Routes for Calculations
  match "/calculations/switch"          => "calculations#switch"
  
  # Routes for testing...
  match "/Test/Calculations"            => "test#calculations" 
  match "/Test/Test_init_market"        => "test#init_markets"
  match "/Test/Generate_Instructions"   => "test#generate_instructions"
  match "/Test/Uploadtestdata"          => "test#uploadFile"
  match "/Test/Uploadtestdata2"         => "test#uploadFile2"
  match "/Test/DoTest"                  => "test#full_calculations_test"
  match "/Test/InitDB"                  => "test#init_database"
#  match "/Test/DelDB"                   => "test#delete_database"
  
   
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
