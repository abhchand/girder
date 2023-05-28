require Rails.root.join('lib', 'superadmin', 'mailer_preview_constraint')

Rails.application.routes.draw do
  root to: 'root#new'

  scope :superadmin do
    mount Sidekiq::Web => '/sidekiq'

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

  # === SUMMARY OF DEVISE ROUTES
  #
  # Items labeled `[UI]` have a corresponding view under `app/view/users/*`
  #
  # +-------------------------------+--------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
  # | `devise/confirmations#new`    | `GET    /users/confirmation/new`     | [UI] to send (or re-send) confirmation email                                                                                   |
  # | `devise/confirmations#create` | `POST   /users/confirmation`         | Generate confirmation email. Called by `#new`                                                                                  |
  # | `devise/confirmations#show`   | `GET    /users/confirmation`         | Validate confirmation. Linked from email. If valid, redirect to `root_path`. If invalid, render `:new` to re-send confirmation.|
  # +-------------------------------+--------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
  # | `devise/passwords#new`        | `GET    /users/password/new `        | [UI] to reset password                                                                                                         |
  # | `devise/passwords#create`     | `POST   /users/password`             | Generate "reset password" email. Called by `#new`. If errors, renders the `#new` template                                      |
  # | `devise/passwords#edit`       | `GET    /users/password/edit`        | [UI] to update the password. Linked from email.                                                                                |
  # | `devise/passwords#update`     | `PUT    /users/password`             | Update the password. Called from `:edit`. If errors, renders the `#new` template                                               |
  # +-------------------------------+--------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
  # | `devise/registrations#new`    | `GET    /users/registrations/new`    | [UI] to sign up (create a new User)                                                                                            |
  # | `devise/registrations#create` | `POST   /users/registrations`        | Create new user. Called by `#new`. If errors, renders the `#new` template                                                      |
  # | `devise/registrations#edit`   | `GET    /users/registrations/edit`   | [UI] to edit a User (UNUSED) - overridden to redirect to `/account`                                                            |
  # | `devise/registrations#update` | `PUT    /users/registrations`        | Updates a user's password only. Called from `/account`                                                                         |
  # | `devise/registrations#cancel` | `GET    /users/registrations/cancel` | Unused. See Devise's `RegistrationController` for description                                                                  |
  # | `devise/registrations#destroy`| `DELETE /users/registrations`        | Delete a User                                                                                                                  |
  # +-------------------------------+--------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+
  # | `devise/sessions#new`         | `GET    /users/log-in`               | [UI] to log in                                                                                                                 |
  # | `devise/sessions#create`      | `POST   /users/log-in`               | Create a new session. Called from `#new`                                                                                       |
  # | `devise/sessions#destroy`     | `GET    /users/log-out`              | Log out                                                                                                                        |
  # +-------------------------------+--------------------------------------+--------------------------------------------------------------------------------------------------------------------------------+

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
