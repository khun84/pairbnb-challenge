module ListingsHelper

    # CONTROLLER HELPER METHOD
    def listings_by_role
        if !signed_in?
            return Listing.where('verified = ?', true).order('updated_at desc').paginate(page:params[:page], per_page: 3)
        end

        if current_user.customer?
            if params.keys.include? 'user_id'
            #     populate listings for host
                return current_user.listings.order('updated_at desc').paginate(page:params[:page], per_page: 3)
            else
            #     populate listings for travel
                return Listing.verified.order('updated_at desc').paginate(page:params[:page], per_page: 3)
            end
        else
            # listings for moderator
            return Listing.not_verified.paginate(page:params[:page], per_page: 3)
        end

    end

    # VIEW HELPER METHOD

    def line_through_class(yes_or_no)
        if yes_or_no == 'Y' or yes_or_no == true
            ''
        else
            'allowed'
        end
    end

    def yes_no_to_boolean(yes_or_no)
        if yes_or_no == 'Y'
            true
        else
            false
        end
    end

    def boolean_to_yes_no(boolean)
        if boolean
            'Y'
        else
            'N'
        end
    end


end
