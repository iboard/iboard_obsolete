ActionController::Routing::Routes.draw do |map|

  map.resources :tickets

  map.resources :events, 
    :collection => { :calendar => :get, :list => :get, :rss => :get }
    
  map.resources :newsletter_templates, 
    :member => { :send_now => :get,
                 :send_one_mail => :put }

  map.resources :newsletter_subscriptions, :collection => { :subscribe => :get },
    :member => { :destroy => :get }
  
  map.resources :newsletters, 
    :member => { :list_subscriptions => :get, 
                 :send_newsletter => :get, 
                 :import_addresses => :get,
                 :create_subscriptions => :post,
                 :remove_addresses => :get,
                 :remove_subscriptions => :post
               }
  
  map.resources :galleries, :member => { :thumbnail => :get}

  map.resources :div_tags

  map.resources :postings, :collection => { :add => :get }

  map.resources :pages, 
    :member => { 
      :show_page => :get, 
      :add_column => :get, 
      :edit_columns => :get,
      :save_columns => :post, 
      :remove_column => :post, 
      :add_existing_column => :put, 
      :add_new_column => :post,
      :page_columns => :get,
      :delete_column => :put 
     }

  map.resources :binaries, :member => { :thumbnail => :get, :original => :get, :embed => :get, :preview => :get,
    :download => :get, :send_image => :get }

  map.resources :functions

  map.resources :accessors

  map.resources :users, :member => { :welcome => :get, :create_registration => :post, :confirmation => :post  },
    :collection => { :registrations => :get, :register => :get }

  map.resources :authors

  # The priority is based upon order of creation: first created -> highest priority.
  map.connect 'application/set_language/:code/:back_to', :controller => 'application', :action => 'set_language'
  
  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  # map.root :controller => "welcome"
  map.logout 'authenticate/logout', :controller => 'authenticate', :action => 'logout'
  map.login  'authenticate/login', :controller => 'authenticate', :action => 'login'
  map.rss    'rss', :controller => 'rss', :action => 'index'
  map.root   :controller => 'pages', :action => 'show_page'
  
  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
  map.connect '*path', :controller => 'pages', :action => 'not_found'
end
