Rails.application.routes.draw do

  root to: 'claims#index'

  resources :redemptions
  resources :appeals
  resources :claims do
    resources :redemptions, only: [:new, :create]
    resources :appeals, only: [:new, :create]
  end

  mount EgovUtils::Engine => '/internals'

end
