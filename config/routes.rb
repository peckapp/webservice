Rails.application.routes.draw do
  require 'api_constraints'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  namespace :api, defaults: {format: 'json'}  do
    # /api/... Api::
    # adds versioning capabilities to the API using separate modules
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      resources :simple_events, :activity_logs, :athletic_events, :athletic_teams, :circle_members, :clubs, :configurations, :departments, :dining_opportunities, :dining_periods, :dining_places,:event_attendees, :event_comments, :event_views, :events_page_urls, :institutions, :locations, :menu_items, :notification_views, :push_notifications, :simple_events, :subscriptions, :user_device_tokens, :users

      resources :circles do
        resources :circle_members
      end

    end
    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
      resources :simple_events
    end
  end
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
