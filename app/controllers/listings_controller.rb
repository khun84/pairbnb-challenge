class ListingsController < ApplicationController
    def index

        # @listings = Listing.all.order(:updated_at).reverse_order
        # @listings = Listing.reorder('updated_at DESC').page(page: params[:page], per_page: 3)
        @listings = Listing.all.order(:updated_at).paginate(page: params[:page], per_page: 3)

        render 'listings/index'
    end

    def new

    end

    def create

    end

    def edit

    end

    def destroy

    end
end
