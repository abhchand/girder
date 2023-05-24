require Rails.root.join('lib', 'sidekiq', 'auth_constraint')
require Rails.root.join('lib', 'superadmin', 'mailer_preview_constraint')

Rails.application.routes.draw do
  root to: 'root#new'

  scope :superadmin do
    mount Sidekiq::Web => '/sidekiq',
          :constraints => Sidekiq::AuthConstraint.new

    # unless Rails.env.production?
    #   get(
    #     '/rails/mailers' => 'rails/mailers#index',
    #     constraints: Superadmin::MailerPreviewConstraint.new,
    #     as: 'superadmin_rails_mailers'
    #   )

    #   get(
    #     '/rails/mailers/*path' => 'rails/mailers#preview',
    #     constraints: Superadmin::MailerPreviewConstraint.new
    #   )
    # end
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

  resources :account, only: %i[index]

  namespace :api, defaults: { format: 'json' } do
    scope path: 'v1', module: :v1, as: :v1 do
      resources :users, only: %i[index show update destroy] do
        post :add_role
        post :remove_role
      end
      resources :user_invitations, only: %i[index create destroy] do
        post :resend
      end
    end
  end

  resources :deactivated_users, only: %i[index destroy]

  resources :photos, only: :index

  resources :product_feedbacks, only: :create

  resources :settings, only: %i[index]
  namespace :settings do
    resources :users, only: %i[index]
    resources :user_roles, only: %i[update]
  end

  resources :users, only: %i[index destroy]
end
