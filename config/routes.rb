require Rails.root.join('lib', 'sidekiq', 'admin_constraint')
require Rails.root.join('lib', 'admin', 'mailer_preview_constraint')

Rails.application.routes.draw do
  root to: 'root#new'

  scope :admin do
    mount Sidekiq::Web => '/sidekiq', constraints: Sidekiq::AdminConstraint.new

    unless Rails.env.production?
      get(
        '/rails/mailers' => 'rails/mailers#index',
        constraints: Admin::MailerPreviewConstraint.new,
        as: 'admin_rails_mailers'
      )

      get(
        '/rails/mailers/*path' => 'rails/mailers#preview',
        constraints: Admin::MailerPreviewConstraint.new
      )
    end
  end

  devise_for(
    :users,
    controllers: {
      confirmations: 'devise/custom/confirmations',
      omniauth_callbacks: 'devise/custom/omniauth_callbacks',
      passwords: 'devise/custom/passwords',
      registrations: 'devise/custom/registrations',
      sessions: 'devise/custom/sessions'
    },
    path_names: {
      sign_in: 'log-in',
      sign_out: 'log-out',
      sign_up: 'new',
      registration: 'registrations'
    },
    sign_out_via: :get
  )

  namespace :account do
    resources :profile, only: :index
  end

  resources :admin, only: %i[index]

  namespace :admin do
    resources :users, only: %i[index]
    resources :user_roles, only: %i[update]
  end

  namespace :api, defaults: { format: 'json' } do
    scope path: 'v1', module: :v1, as: :v1 do
      resources :users, only: %i[index show update destroy] do
        post :add_admin
        post :remove_admin
      end
      resources :user_invitations, only: %i[index] do
        post :resend
      end
    end
  end

  resources :deactivated_users, only: %i[index destroy]

  resources :photos, only: :index

  resources :product_feedbacks, only: :create

  namespace :account do
    resources :profile, only: :index
  end

  resources :users, only: %i[index destroy]

  resources :user_invitations, only: %i[create destroy]
end
