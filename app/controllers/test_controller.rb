class TestController < ApplicationController
    def new
        @listing = Listing.new
        @locations = Location.all.order(:state)
        render 'listings/new'
    end

    def test
        render 'testing'
    end
end
