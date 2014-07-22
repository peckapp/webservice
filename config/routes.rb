
# enables the sidekiq job interface to be displayed
require 'sidekiq/web'
require 'sidetiq/web'
# simplifies the versioning constraints for API interactions
require 'api_constraints'

Rails.application.routes.draw do

  # Active Admin route configuration
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  namespace :api, defaults: {format: 'json'}  do
    # /api/... Api::
    # adds versioning capabilities to the API using separate modules
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      resources :simple_events, :activity_logs, :athletic_events, :athletic_teams, :clubs, :configurations, :departments, :dining_opportunities, :dining_periods, :dining_places,:event_attendees, :comments, :event_views, :events_page_urls, :institutions, :locations, :menu_items, :notification_views, :push_notifications, :simple_events, :subscriptions, :user_device_tokens, :explore

      resources :access, :only => [:create, :destroy] 

      resources :users do
        member do
          patch :super_create
        end
      end

      # Separation by circles
      resources :circles do
        resources :circle_members, :activity_logs
      end

      # Separation by dining places
      resources :dining_places do
        resources :menu_items, :dining_opportunities, :dining_periods
      end

      # Separation by menu items
      resources :menu_items do
        resources :dining_places, :dining_periods
      end

      # Separation by dining periods
      resources :dining_periods do
        resources :menu_items, :dining_opportunities, :dining_places
      end


      # Inviters for a particular circle member
      resources :circle_members do
        resources :users
      end

      # Separation by users
      resources :users do
        resources :circle_members, :circles, :activity_logs, :user_device_tokens
      end

      # Dining periods for a particular dining opportunity
      resources :dining_opportunities do
        resources :dining_places
      end

      # Users for a particular user device token
      resources :user_device_tokens do
        resources :users
      end

      # separation by institutions
      resources :institutions do
        resources :users, :simple_events, :circles, :circle_members, :athletic_events, :athletic_teams, :clubs, :departments, :dining_opportunities, :dining_periods, :dining_places
      end

      # separation by athletic teams
      resources :athletic_teams do
        resources :athletic_events
      end
    end

    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
      resources :simple_events
    end
  end


  # api status and version information
  get 'api', to: 'api#index', via: [:get]

  mount Sidekiq::Web, at: '/tasks'

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
