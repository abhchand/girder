Rails.application.routes.draw do
  # rubocop:disable Style/SymbolArray
  root to: "site#index"

  mount Sidekiq::Web => "/sidekiq", constraints: Sidekiq::AdminConstraint.new

  post "/log-in", to: "sessions#create"
  get "/log-out", to: "sessions#destroy"

  resources :photos, only: :index
  resources :settings, only: :index
  # rubocop:enable Style/SymbolArray
end
