Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations', passwords: 'users/passwords' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"

  devise_scope :user do
    get 'users/two_factor_auth', to: 'users/sessions#two_factor_auth'
  end

  resources :home, only: :index
  resources :impressions, only: %i[index show]

  namespace :my_page do
    resources :articles, only: :create
    resources :impressions do
      collection do
        post :update_article
      end
      member do
        patch :publish
      end
    end
    resources :two_step_verifications, only: %i[new create]
  end

  namespace :admin do
    resources :users
    resources :articles, only: %i[index show edit update]
    resources :musics, except: :destroy
    resources :creators, except: :destroy

    namespace :shared do
      resources :musics, except: %i[edit]
      resources :creators, except: %i[edit]
    end
  end
end
