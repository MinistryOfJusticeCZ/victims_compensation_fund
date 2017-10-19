Rails.application.routes.draw do

  root to: 'claims#index'

  resources :redemptions
  resources :appeals do
    resources :satisfactions
  end
  resources :satisfactions, only: [:index, :new, :create]
  resources :claims do
    resources :redemptions, only: [:new, :create]
    resources :appeals, only: [:new, :create]
  end

  mount EgovUtils::Engine => '/internals'

end
