Rails.application.routes.draw do
  devise_for :users,
  controllers: {
    confirmations: "auth/confirmations",
    passwords: "auth/passwords",
    registrations: "auth/registrations",
    sessions: "auth/sessions",
    unlocks: "auth/unlocks"
  },
  path: "",
  path_names: {
    sign_in: "login",
    sign_up: "register",
    sign_out: "logout",
    confirmation: "validation",
    unlock: "unblock",
    password: "secret",
    edit: "profile"
  }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"
  authenticated :user, ->(user) { user.admin? } do
    namespace :admin do
      root "dashboard#index"
    end
    root to: redirect("/admin"), as: :admin_authenticated_root
  end


  authenticated :user, ->(user) { user.user? } do
    namespace :user do
      root "dashboard#index"
    end
    root to: redirect("/user"), as: :user_authenticated_root
  end

  root "home#index", as: :public_root
end
