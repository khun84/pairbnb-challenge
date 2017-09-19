Rails.application.routes.draw do
    resources :passwords, controller: "clearance/passwords", only: [:create, :new]
    resource :session, controller: "sessions", only: [:create]

    resources :users, controller: "users", only: [:create] do
        resource :password,
                 controller: "clearance/passwords",
                 only: [:create, :edit, :update]
        resource :listings, controller: 'listings'
    end

    resources :listings

    root 'static#index'

    post "/sign_in" => "sessions#create", as: "sign_in"
    delete "/sign_out" => "sessions#destroy", as: "sign_out"
    post "/sign_up" => "users#new", as: "sign_up"
    # get '/test_sign_in' => "sessions#new", as: 'test_sign_in'

    get "/auth/:provider/callback" => "sessions#create_from_omniauth"
end
