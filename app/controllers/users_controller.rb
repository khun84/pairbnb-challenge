class UsersController < Clearance::UsersController
    before_action(only: [:show, :edit, :update, :destroy]) do
        not_sign_in_redirect url: root_path, msg: 'Please sign in to perform this action'
    end

    before_action(only: [:edit, :update, :destroy]) do
        resource_exist? url: listings_path, resource: Listing, resource_id: params[:id], msg: 'There is no such listing'
        belongs_to_current_user? url: listing_path(params[:id]), resource: Listing, resource_id: params[:id], msg: "You can only edit your own listing"
    end

    def new
        @user = User.new
        render "users/new"
    end

    def create
        @user = User.new user_params

        if @user.save
            sign_in @user
            redirect_back_or url_after_create
        else
            render template: "users/new"
        end
    end

    def show
        @user = User.find(params[:id])
        @listings = @user.listings.order('updated_at DESC').paginate(page: params[:page], per_page: 3)
        @avoid_footer = 'avoid-footer'
        render 'show'
    end

    def user_params
        params.require(:user).permit(:email, :name, :state, :country, :password)
    end

    def edit

    end

    def update
        not_sign_in_redirect msg: 'Please sign in to perform this action'

        @user = User.find(params[:id])
        @user.update_attributes(user_params.except(:email))
        if @user.save
            redirect_to user_path(current_user)
            return
        else
            redirect_to edit_user_path(current_user)
            return
        end
    end
end

