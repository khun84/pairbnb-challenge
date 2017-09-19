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
        render 'listings/new'
    end

    def create
        new_listing = current_user.listings.new(listing_params(params))
        if new_listing.save
            redirect listing_path(new_listing)
        else
            new_listing.errors.messages
        end
    end

    def edit

    end

    def destroy

    end

    def listing_params(params)
        params.require(:listing).permit([:name, :location_id, :person_count, :base_price, :smoke, :pet, :user_id])
    end
end
