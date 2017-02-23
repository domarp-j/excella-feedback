Rails.application.routes.draw do
  # Root path
  root 'static#home'

  # Devise routes, controller override
  devise_for :users, :controllers => { registrations: 'registrations' }

  # Routes for presentations
  resources :presentations
end
