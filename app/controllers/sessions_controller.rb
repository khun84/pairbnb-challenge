class SessionsController < Clearance::SessionsController


    # override superclass method
    def create
        @user = authenticate(params)

        sign_in(@user) do |status|
            if status.success?
                redirect_back_or url_after_create
            else
                flash.now.notice = status.failure_message
                # render template: "sessions/new", status: :unauthorized
                # todo throw a sign in failure msg to user
                redirect_to root_path
            end
        end
    end

    # create authentication for sign in or sign up
    def create_from_omniauth
        auth_hash = request.env["omniauth.auth"]
        authentication = Authentication.find_by_provider_and_uid(auth_hash["provider"], auth_hash["uid"]) ||  Authentication.create_with_omniauth(auth_hash)

        # if: previously already logged in with OAuth
        if authentication.user
            user = authentication.user
            authentication.update_token(auth_hash)
            @next = root_url
            @notice = "Signed in!"
            # else: user logs in with OAuth for the first time
        else
            user = User.create_with_auth_and_hash(authentication, auth_hash)
            # you are expected to have a path that leads to a page for editing user details
            # TODO Direct user to their profile page and confirm their personal information
            @next = root_path
            @notice = "User created. Please confirm or edit details"
        end

        sign_in(user)
        redirect_to @next, :notice => @notice
    end

    def params_from_sign_in
        params_sign_in[:session][:email] = params['session']['email']
        params_sign_in[:session][:password]=params['session']['password']
    end

    private

    def redirect_signed_in_users
        if signed_in?
            redirect_to url_for_signed_in_users
        end
    end

    def url_after_create
        #  TODO change to listing index page
        root_path
        # Clearance.configuration.redirect_url
    end

    def url_after_destroy
        root_path
        # sign_in_url
    end

    def url_for_signed_in_users
        url_after_create
    end
end
