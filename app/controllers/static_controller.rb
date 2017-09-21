class StaticController < ApplicationController
    include ListingsHelper
    def index
        @listings = listings_by_role
        render 'static/index'
    end
end
