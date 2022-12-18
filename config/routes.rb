Rails.application.routes.draw do
  devise_for :users, controllers: { sessions: 'users/sessions', registrations: 'users/registrations' }

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root "home#index"

  resources :home, only: :index
  resources :my_page, only: :index
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
  end

  namespace :admin do
    resources :users
    resources :articles, except: :destroy
    resources :musics, except: :destroy
    resources :creators, except: :destroy

    namespace :shared do
      resources :musics, except: %i[edit]
      resources :creators, except: %i[edit]
    end
  end
end
