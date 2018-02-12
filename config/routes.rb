Rails.application.routes.draw do

  root to: 'claims#index'

  resources :redemptions
  resources :appeals do
    resources :satisfactions
  end
  resources :debts #, only: [:index, :new, :create]
  resources :satisfactions, only: [:index, :new, :create]
  resources :claims do
    resources :redemptions, only: [:new, :create]
    resources :appeals, only: [:new, :create]
    resources :debts, only: [:new, :create]
  end

  resources :victims, only: :index
  resources :offenders, only: :index

  mount EgovUtils::Engine => '/internals'

  apipie

  namespace :api do
    concern :api_base do
      resources :ires_batch, only: [:create]
    end

    namespace :v1 do
      concerns :api_base
    end
  end


  require 'sidekiq/api'
  get "queue-status" => proc { [200, {"Content-Type" => "text/plain"}, [Sidekiq::Queue.new.size < 100 ? "OK" : "UHOH" ]] }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

end
