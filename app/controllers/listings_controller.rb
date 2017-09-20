class ListingsController < ApplicationController
    def index

        # @listings = Listing.all.order(:updated_at).reverse_order
        # @listings = Listing.reorder('updated_at DESC').page(page: params[:page], per_page: 3)
        @listings = Listing.all.order(:updated_at).paginate(page: params[:page], per_page: 3)

        render 'listings/index'
    end

    def new
        @listing = Listing.new
        @locations = Location.all
        @avoid_footer = 'avoid-footer'
        render 'listings/new'
    end

    def create
        new_listing = current_user.listings.new(listing_params(params))
        @avoid_footer = 'avoid-footer'
        if new_listing.save
            redirect listing_path(new_listing)
        else
            new_listing.errors.messages
        end
    end

    def show
        @listing = Listing.includes(:location).find(params[:id])
        flash.now[:notice] = ['Showing your listing']
    end

    def edit
        @listing = current_user.listings.find(params[:id])
        # todo what if the listing has been deleted
        @locations = Location.all

    end

    def update
        @listing = Listing.find(params[:id])
        @listing.update_attributes(listing_params.except(:user_id))
        redirect_to @listing
    end

    def destroy

    end

    def listing_params
        params.require(:listing).permit([:name, :location_id, :person_count, :base_price, :smoke, :pet, :user_id, :room_count])
    end
end
