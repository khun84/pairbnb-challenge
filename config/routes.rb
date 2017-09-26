Rails.application.routes.draw do
    resources :passwords, controller: "clearance/passwords", only: [:create, :new]
    resource :session, controller: "sessions", only: [:create]

    # users resources
    resources :users, controller: 'users', only: [:index, :show, :edit, :update]
    resources :users, controller: "users", only: [:create] do
        resource :password,
                 controller: "clearance/passwords",
                 only: [:create, :edit, :update]
        resources :listings, except: [:destroy]
    end


    get '/listings/search' => 'listings#search', as: :search_listings

    # listings resources
    resources :listings, only: [:index, :show] do
        resources :reservations

        member do
            get 'verify/edit' => 'listings#edit_by_moderator', as: :edit_by_moderator
            # patch 'verify' => 'listings#update_verified', as: :update_verify
        end
    end



    # reservations resources
    post '/reservations/:reservation_id/payments' => 'payments#checkout', as: :reservation_check_out

    # this path for email testing only
    # get '/reservations/email' => 'reservations#send_email', as: :reservation_email

    resources :reservations do
        resources :payments
    end

    delete '/users/:user_id/listings/:id' => 'listings#destroy', as: :delete_user_listing

    # reservations resources

    root 'static#index'

    ####### AUTHENTICATION
    post "/sign_in" => "sessions#create", as: "sign_in"
    delete "/sign_out" => "sessions#destroy", as: "sign_out"
    post "/sign_up" => "users#new", as: "sign_up"
    get "/auth/:provider/callback" => "sessions#create_from_omniauth"
    ####### AUTHENTICATION END

    get '/test' => 'test#test', as: 'testing'


end
