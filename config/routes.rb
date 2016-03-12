Rails.application.routes.draw do
  devise_for :users

  resources :designs
  resources :sides
  resources :artifacts do
    member do
      get 'copy_props'
    end
  end
  resources :properties

  scope '/manage' do
    resources :users
  end

  root 'badges#new'

  resources :badges do
    member do
      get 'camera'    # takes image
      get 'print'     # prints badge
      get 'generate'  # generate badge

      get 'crop'      # crops picture
      post 'snapshot' # uploads snapshot
    end
  end

  post 'lookup' => 'badges#lookup', as: :lookup
end
