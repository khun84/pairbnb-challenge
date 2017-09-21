class ListingsController < ApplicationController
    include ListingsHelper

    before_action(except: [:show, :index]) do
        not_sign_in_redirect url: listings_path, msg: 'Please sign in to perform this action'
    end

    before_action(except: [:index, :new, :create]) do
        resource_exist? url: listings_path, resource: Listing, resource_id: params[:id], msg: 'There is no such listing'
    end

    before_action(only: [:edit]) do
        continue = is_moderator? url: edit_by_moderator_listing_path, msg: 'Entering moderator editing mode'

        if continue
            belongs_to_current_user? url: listing_path(params[:id]), resource: Listing, resource_id: params[:id], msg: "You can only edit your own listing"
        end
    end

    before_action(only: [:update, :destroy]) do

        if !current_user.moderator?
            belongs_to_current_user? url: listing_path(params[:id]), resource: Listing, resource_id: params[:id], msg: "You can only edit your own listing"
        end
    end



    def index
        @listings = listings_by_role
        render 'listings/index'
    end

    def new
        @listing = Listing.new
        @locations = Location.all
        @avoid_footer = 'avoid-footer'
        render 'listings/new'
    end

    def create
        new_listing = current_user.listings.new(listing_params)
        @avoid_footer = 'avoid-footer'
        if new_listing.save
            redirect_to listing_path(new_listing)
        else
            new_listing.errors.messages
        end
    end

    def show
        @listing = Listing.includes(:location).find(params[:id])
    end

    def edit
        @listing = current_user.listings.find(params[:id])
        # todo what if the listing has been deleted
        @locations = Location.all

    end

    def edit_by_moderator
        @listing = Listing.find(params[:id])
        @locations = Location.all
        render 'edit'
    end

    def update

        @listing = Listing.find(params[:id])
        if current_user.moderator?
            role_params = moderator_params
        else
            role_params = listing_params.except([:user_id, :verified])
            role_params['verified'] = yes_no_to_boolean(role_params['verified'])
        end
        byebug
        @listing.update_attributes(role_params)
        if @listing.save
            flash[:notice] = 'You have editted this listing'
        else
            flash[:notice] = @listing.errors.messages
        end

        redirect_to @listing
    end



    def destroy
        if !params[:user_id].nil?
            listing = Listing.find(params[:id])
            listing.destroy
            return redirect_to current_user, notice: 'The listing has been deleted!'
        end

    end

    private

    def listing_params
        params.require(:listing).permit([:name, :location_id, :person_count, :base_price, :smoke, :pet, :user_id, :room_count])
    end

    def moderator_params
        params.require(:listing).permit([:verified])
    end
end
