BookBuy::Application.routes.draw do

  resources :worklists
  resources :publishers
  resources :suppliers
  resources :pos
  resources :invoices do
    get 'regenerate', :on => :member
  end
  resources :bookreceipts
  resources :titlereceipts
  resources :crates do
    member do
      get 'fill'
      get 'regenerate'
    end
  end

  match '/dashboard' => 'dashboard#show'

  match 'worklist_save_items_with_invalid_isbn'             => 'worklists#save_items_with_invalid_isbn'
  match 'worklist_save_items_with_details_not_enriched'     => 'worklists#save_items_with_details_not_enriched'
  match 'worklist_save_items_with_po_not_generated'         => 'worklists#save_items_with_po_not_generated'
  
  match 'bookreceipts/fetch' => 'bookreceipts#fetch', :method => :post
  
  match '/auth/:provider/callback' => 'authentications#create'
  devise_for :users, :path => 'accounts', :controllers => {:registrations => 'registrations'}

  match '/auth/failure' => 'Dashboard#show'
  resources :authentications, :branches

  match '/invoices/new_with_supplier'                              => 'invoices#new_with_supplier'
  
  # after all the routing
  root :to => "Dashboard#show"

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
  # root :to => "welcome#index"

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id(.:format)))'
end
