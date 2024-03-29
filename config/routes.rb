Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "impressions#index"

  devise_scope :user do
    patch 'users/switch_show_name', to: 'users/registrations#switch_show_name'
    get 'users/two_factor_auth', to: 'users/sessions#two_factor_auth'
  end

  resources :creators, only: %i[index show] do
    resources :articles, only: %i[show], module: :creators
  end
  namespace :impressions do
    resources :tags, only: %i[index update destroy]
  end
  resources :impressions, only: %i[index show]
  resources :articles, only: %i[show]

  namespace :my_page do
    resources :impressions do
      collection do
        post :update_article
        get :download
      end
      member do
        patch :publish
        post :post_mastodon
      end
    end
    resources :impression_tags, only: %i[index new create destroy] do
      collection do
        post :show_all_tags
        post :add_tag
      end
    end
    resources :two_step_verifications, only: %i[new create]
    resources :tag_groups do
      member do
        get :edit_tags
        post :add_tag
        delete :destroy_tag
      end
    end
  end

  namespace :admin do
    resources :users
    resources :articles, only: %i[index show edit update] do
      member do
        get :reset
      end
    end
    resources :impressions, only: %i[index show destroy]
    resources :musics, except: :destroy
    resources :creators, except: :destroy
    resource :mastodon_data_linkage do
      collection do
        get :callback
      end
    end

    namespace :shared do
      resources :musics, except: %i[edit] do
        collection do
          post :show_music
        end
      end
      resources :creators, except: %i[edit]
    end
  end

  namespace :notices do
    resources :zakkuri_festival, only: %i[index]
  end
end
