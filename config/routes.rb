
# enables the sidekiq job interface to be displayed
require 'sidekiq/web'
require 'sidetiq/web'
# simplifies the versioning constraints for API interactions
require 'api_constraints'

Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".
  resources :registrations do
    member do
      get :confirm_email
    end

    collection do
      get :apple, :android
    end
  end

  resources :deep_links do
    collection do
      get :native_peck, :apple, :android
    end
  end

  resources :mobile_resets do
    collection do
      get :desktop, :apple, :android, :nonmobile
    end
  end

  namespace :api, defaults: { format: 'json' }  do
    # /api/... Api::
    # adds versioning capabilities to the API using separate modules
    scope module: :v1, constraints: ApiConstraints.new(version: 1, default: true) do

      resources(:activity_logs, :athletic_events, :athletic_teams, :clubs, :circles, :configurations,
                :departments, :dining_opportunities, :dining_periods, :dining_places, :event_views,
                :events_page_urls, :institutions, :locations, :menu_items, :notification_views,
                :pecks, :unique_device_identifiers, :explore)

      resources :access, only: [:create] do
        collection do
          delete :logout
        end
      end

      resources :announcements do
        member do
          patch :add_like, :unlike
        end
      end

      resources :circle_members do
        collection do
          delete :leave_circle
        end

        member do
          patch :accept
        end
      end

      resources :event_attendees do
        collection do
          delete :destroy
        end
      end

      resources :subscriptions do
        collection do
          delete :destroy
        end
      end

      resources :simple_events do
        member do
          patch :add_like, :unlike
        end

        collection do
          get :check_time_conflicts
        end
      end

      resources :comments do
        member do
          patch :add_like, :unlike
        end
      end

      resources :users do
        member do
          patch :super_create, :change_password, :facebook_login
          get :user_circles, :user_announcements
        end

        collection do
          post :user_for_udid
          get :check_link, :reset_password
        end
      end
    end

    scope module: :v2, constraints: ApiConstraints.new(version: 2) do
      resources :simple_events
    end
  end

  # Active Admin route configuration
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # sidekiq background jobs panel
  authenticated :admin_user do
    mount Sidekiq::Web, at: '/tasks'
  end

  # api status and version information
  get 'api', to: 'api#index', via: [:get]

  # You can have the root of your site routed with "root"
  if Rails.env.production?
    root 'api#main_redirect'
  else
    root 'api#index'
  end

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
