Rails.application.routes.draw do

  root to: 'claims#index'

  resources :payments
  resources :appeals
  resources :claims do
    resources :payments, only: [:new, :create]
    resources :appeals, only: [:new, :create]
  end

  mount EgovUtils::Engine => '/internals'

end
