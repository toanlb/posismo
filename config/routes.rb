# -*- coding: utf-8 -*-
Twopm::Application.routes.draw do
  #######################
  ### Routes for Devise
  ### Cautioin! You must write "devise_for" upper than "resources".  
  devise_for :partners, :path => :partner, :path_names => { 
    :sign_in => 'login', 
    :sign_out => 'logout',
    :sign_up => 'register',
    :registration => 'registration' }, :controllers => { :registrations => "partner/registrations" }
  devise_for :clients, :path => :client, :path_names => { 
    :sign_in => 'login', 
    :sign_out => 'logout',
    :sign_up => 'register',
    :registration => 'registration' }, :controllers => { :registrations => "client/registrations" }
  devise_for :admins, :path => :admin, :path_names => { 
    :sign_in => 'login', 
    :sign_out => 'logout' }
    
  ########################
  ### Admin routes
  #scope :module => :admin do
  #	resource :admin, :only => [ :show, :edit, :update ]
  #end
  namespace :admin do
    get "/top" => "admin#index", :as => :root # 管理者トップ
    get "manage" => "admin#manage" # 管理業務
    resources :notices do
      get "delete", :on => :member
    end
    get "bills" => "admin#bills" # 支払い・請求管理
    get "notifications" => "admin#notifications" # 通知管理
    get "account" => "admin#show" # アカウント情報
    get "account/edit" => "admin#edit" # アカウント情報
    get "payment" => "admin#payment" #支払い情報
    post "account" => "admin#update" # アカウント情報
    resources :admins do # 管理者アカウント管理
      get "delete", :on => :member
    end
    
    get "client_monthlies" => "client_monthlies#index"
    get "partner_monthlies" => "partner_monthlies#index"
    get "clients/csv" => "clients#csv", :format => :csv
    get "partners/csv" => "partners#csv", :format => :csv
    resource :account_managements, :except => [:edit, :update, :destroy, :show]
    resources :clients do
      resource :account_managements, :except => [:new, :create, :destroy, :show]
      get "top", :on => :member
      get "delete", :on => :member

      get "promotions/upload" => "promotions#upload"
      post "promotions/uploaded" => "promotions#uploaded"
      post "promotions/csv" => "promotions#csv", :format => :csv
      get "promotions/csv" => "promotions#csv", :format => :csv
      resources :promotions do
        get "delete", :on => :member
        get "toggle_active", :on => :member
        get "conversion_tag", :on => :member
        resources :rewards do
          get "delete", :on => :member
        end     
        
        resource :one_tags, :except => [:create, :new, :destroy]
        resources :banners do
          post "image", :on => :collection
          get "image_cache/:cache_name" => "#image_cache", :on => :collection
          get "delete", :on => :member
        end
      end
      get "promotions/child_categories/:parent_id" => "promotions#child_categories", :format => :json

      get "publishes/upload" => "publishes#upload"
      post "publishes/uploaded" => "publishes#uploaded"
      post "publishes/csv" => "publishes#csv", :format => :csv
      get "publishes/csv" => "publishes#csv", :format => :csv
      post "publishes" => "publishes#index"
      resources :publishes do
        member do
          post "approve"
          post "reject"
          post "defer"
        end
        resource :conversiontags
      end
      
      get "orders/upload" => "orders#upload"
      post "orders/uploaded" => "orders#uploaded"
      get "orders/csv" => "orders#csv", :format => :csv
      post "orders/csv" => "orders#csv", :format => :csv
      get "orders/promotion_publishes_sites/:promotion_id" => "orders#promotion_publishes_sites", :format => :json
      get "publishes/promotion_publishes_sites/:promotion_id" => "statistics#promotion_publishes_sites", :format => :json
      resources :orders do
        post "approve" => "orders#approve", :on => :collection
        post "reject" => "orders#reject", :on => :collection
        post "defer" => "orders#defer", :on => :collection
        get "delete", :on => :member
      end

      get "statistics/upload" => "statistics#upload"
      post "statistics/uploaded" => "statistics#uploaded"
      post "statistics/csv" => "statistics#csv", :format => :csv
      post "statistics_month/csv" => "statistics#csvmonth", :format => :csv
      get "statistics/promotion_publishes_sites/:promotion_id" => "statistics#promotion_publishes_sites", :format => :json
      resources :statistics, :only => [ :index ]
      post "statistics" => "statistics#index"
      get "statistics" => "statistics#index"
      get "statistics_month" => "statistics#index_month"
      post "statistics_month" => "statistics#index_month"
      #resources :dailies do
        #resources :dailies, :only => [ :index ]
      #end
      resources :asps do
        get "delete", :on => :member
      end
      resources :payments, :only => [ :index ]
      get "dailies" => "payments#index"
      
    end
 
    resources :partners do
      collection do
        get "top"
        post "approve"
        post "reject"
        post "interim"
      end
      get "delete", :on => :member
    end
    
    resources :payments

  end
  
  ########################
  ### Client routes
  namespace :client do
    get "/top" => "client#index", :as => :root
    get "account" => "client#show" # アカウント情報
    get "account/edit" => "client#edit" # アカウント情報
    get "account/thanks" => "client#thanks" # アカウント情報
    put "account/update" => "client#update" # アカウント情報
    
    get "promotions/upload" => "promotions#upload"
    post "promotions/uploaded" => "promotions#uploaded"
    get "promotions/csv" => "promotions#csv", :format => :csv
    resources :promotions do
      get "delete", :on => :member
      get "toggle_active", :on => :member
      get "conversion_tag", :on => :member
      resources :rewards do
        get "delete", :on => :member
      end
      
      resource :one_tags, :except => [:create, :new, :destroy]
      resources :banners do
          post "image", :on => :collection
          get "image_cache/:cache_name" => "#image_cache", :on => :collection
          get "delete", :on => :member
      end
    end
    get "promotions/child_categories/:parent_id" => "promotions#child_categories", :format => :json
    
    get "publishes/upload" => "publishes#upload"
    post "publishes/uploaded" => "publishes#uploaded"
    get "publishes/csv" => "publishes#csv", :format => :csv
    post "publishes/csv" => "publishes#csv", :format => :csv
    post "publishes" => "publishes#index"
    get "publishes/promotion_publishes_sites/:promotion_id" => "statistics#promotion_publishes_sites", :format => :json
    resources :publishes do
      member do
        post "approve"
        post "reject"
        post "defer"
      end
    end
    
    get "orders/upload" => "orders#upload"
    post "orders/uploaded" => "orders#uploaded"
    get "orders/csv" => "orders#csv", :format => :csv
    get "orders/promotion_publishes_sites/:promotion_id" => "orders#promotion_publishes_sites", :format => :json
    resource :orders do
      get "show" => "orders#index"
      post "approve" => "orders#approve"
      post "reject" => "orders#reject"
      post "defer" => "orders#defer"
    end
    
    get "statistics/upload" => "statistics#upload"
    post "statistics/uploaded" => "statistics#uploaded"
    get "statistics/csv" => "statistics#csv", :format => :csv
    post "statistics/csv" => "statistics#csv", :format => :csv
    get "statistics_month/csv" => "statistics#csvmonth", :format => :csv
    post "statistics_month/csv" => "statistics#csvmonth", :format => :csv
    get "statistics/promotion_publishes_sites/:promotion_id" => "statistics#promotion_publishes_sites", :format => :json
    resources :statistics, :only => [ :index ]
      post "statistics" => "statistics#index"
      get "statistics_month" => "statistics#index_month"
      post "statistics_month" => "statistics#index_month"
      
    resources :notices, :only => [:index, :show]
    resources :payments, :only => [ :index ]
    get "dailies" => "payments#index"
    post "dailies" => "payments#index"
  end
  
  ########################
  ### Partner routes
  namespace :partner do
    get "/top" => "partner#index", :as => :root
    get "account" => "partner#show" # アカウント情報
    get "account/edit" => "partner#edit" # アカウント情報
    get "account/thanks" => "partner#thanks" # アカウント情報
    get "account/preresign" => "partner#preresign" # アカウント情報
    post "account/resign" => "partner#resign" # アカウント情報
    put "account/update" => "partner#update" # アカウント情報

    get "sites/csv" => "sites#csv", :format => :csv
    post "sites/csv" => "sites#csv", :format => :csv
	  resources :sites do
	    get "delete", :on => :member
	  end
	  get "sites/child_categories/:parent_id" => "sites#child_categories", :format => :json
	  
	  get "promotions/csv" => "promotions#csv", :format => :csv
    resources :promotions do
      match "affiliate", :on => :member
    end
    
    post "publishes" => "publishes#index"
    get "publishes/csv" => "publishes#csv", :format => :csv
    resources :publishes do
      get "delete", :on => :member
    end
    
    get "dailies/csv" => "payments#csv", :format => :csv
    resources :payments, :only => [ :index ]
    get "dailies" => "payments#index"
    
    get "statistics/csv" => "statistics#csv", :format => :csv
    post "statistics/csv" => "statistics#csv", :format => :csv
    get "statistics_month/csv" => "statistics#csvmonth", :format => :csv
    post "statistics_month/csv" => "statistics#csvmonth", :format => :csv
    get "statistics/promotion_publishes_sites/:promotion_id" => "statistics#promotion_publishes_sites", :format => :json
    resources :statistics, :only => [ :index ]
    post "statistics" => "statistics#index"
    get "statistics_month" => "statistics#index_month"
    post "statistics_month" => "statistics#index_month"
    
    get "orders/csv" => "orders#csv", :format => :csv
    get "orders/pointback" => "orders#pointback", :format => :csv
    resource :orders, :only => [ :index ] do
      get "show" => "orders#index"
    end
    
    resources :notices, :only => [:index, :show]
  end
	
  ###############
  ### root_path 
  root :to => redirect("/home")
  match "/home" => "home#index"
  match "*path" => "application#routing_error"
end
