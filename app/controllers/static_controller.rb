class StaticController < ApplicationController

    def index
        @listings = Listing.all.order(:updated_at).reverse_order.paginate(page:params[:page], per_page: 3)
        render 'static/index'
    end

end
