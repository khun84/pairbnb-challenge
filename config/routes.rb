Rails.application.routes.draw do
    resources :passwords, controller: "clearance/passwords", only: [:create, :new]
    resource :session, controller: "sessions", only: [:create]

    resources :users, controller: "users", only: [:create] do
        resource :password,
                 controller: "clearance/passwords",
                 only: [:create, :edit, :update]
        resource :listings
    end

    resources :listings, only: [:index, :show]

    root 'static#index'

    ####### AUTHENTICATION
    post "/sign_in" => "sessions#create", as: "sign_in"
    delete "/sign_out" => "sessions#destroy", as: "sign_out"
    post "/sign_up" => "users#new", as: "sign_up"
    get "/auth/:provider/callback" => "sessions#create_from_omniauth"
    ####### AUTHENTICATION END


end
