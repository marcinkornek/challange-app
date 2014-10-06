Rails.application.routes.draw do

  devise_for :users, :controllers => { omniauth_callbacks: "users/omniauth_callbacks",
                                       registrations: "users/registrations" }

  root to: 'questions#index'

  resources :questions do
    member do
      post :like_question, :dislike_question
    end
    resources :opinions
    resources :answers, only: [:create] do
      member do
        post :like_answer, :dislike_answer
      end
      resources :opinions
    end
  end

  resources :users, only: [:index, :show] do
    member do
      get :questions, :answers
    end
  end

  resources :notifications, only: [:index, :update] do
    collection do
      post 'update_selected', as: :update_selected
    end
  end

  post    'update_all_notifications',   to: 'notifications#update_all',     as: :update_all_notifications
  post    'pusher/auth',                to: 'pusher#auth',                  as: :pusher_auth
  match   'about',                      to: 'users#about',                  via: 'get'
  get     'tags/:tag',                  to: 'questions#index',              as: :tag
  get     'tags',                       to: 'questions#tags',               as: :tags

end
