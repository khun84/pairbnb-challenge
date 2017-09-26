class ReservationsController < ApplicationController

    before_action do
        # todo different routing for moderator, guest and host
        # moderator and guest should be redirected to reservation profile
        # host should be redirected to listing page
        not_sign_in_redirect url: listings_path, msg: 'Please sign in to perform this action'
    end

    # the listing should exist for the following action
    before_action(only: [:new, :create]) do
        # todo different routing for moderator, guest and host
        resource_exist? url: listings_path, resource: Listing, resource_id: params[:listing_id], msg: 'The listing that you would like to book does not exist.'
    end

    # the reservation should exist for the following action
    before_action only: [:show, :edit] do
        resource_exist? url: listings_path, resource: Reservation, resource_id: params[:id], msg: 'The reservation that you would like to view does not exist'
    end

    before_action(only: [:edit]) do
        # continue = is_moderator? url: edit_by_moderator_listing_path, msg: 'Entering moderator editing mode'
        #
        # if continue
        #     belongs_to_current_user? url: listing_path(params[:id]), resource: Listing, resource_id: params[:id], msg: "You can only edit your own listing"
        # end
    end

    before_action(only: [:update, :destroy]) do

        # if !current_user.moderator?
        #     belongs_to_current_user? url: listing_path(params[:id]), resource: Listing, resource_id: params[:id], msg: "You can only edit your own listing"
        # end
    end

    # the index is able to response to following scenarios
    # 1. show all reservation, required current_user.moderator
    # 2. show all reservations for current user as a traveller
    # 3. show all reservations for current user as a host, required :user_id
    # 4. show all reservations of a listing for current user as a host, required: :listing_id
    def index
        @is_host = false
        if current_user.moderator?
            @reservations = Reservation.all.includes(:listing)
        elsif params.keys.include? 'user_id'
            @reservations = current_user.get_listings_reservations.includes(:listing)
            @is_host = true
        elsif params.keys.include? 'listing_id'
        #     show reservations for host
            @reservations = current_user.listings.find(params[:listing_id]).reservations.includes(:listing)
            @is_host = true
        else
            @reservations = current_user.reservations.includes(:listing)
        end

        render 'index'
    end

    # the show is able to response to following scenarios
    # 1. show the reservation, required current_user.moderator
    # 2. show the reservations for current user as a traveller
    # 3. show the reservations for current user as a host, required :user_id
    # 4. show the reservations of a listing for current user as a host, required: :listing_id
    def show
        if current_user.moderator?
            @reservation = Reservation.includes(:listing).find(params[:id])
        elsif params.keys.include? 'user_id'
            @reservation = current_user.get_listings_reservations.includes(:listing).find(params[:id])
        elsif params.keys.include? 'listing_id'
            @reservation = current_user.listings.find(params[:listing_id]).reservations.includes(:listing).find(params[:id])
        else
            @reservation = current_user.reservations.includes(:listing).find(params[:id])
        end

        render 'show'

    end

    def new

    end

    def create
        assign_param = reservation_params
        assign_param[:check_in] = Date.strptime(assign_param[:check_in], '%Y-%m-%d')
        assign_param[:check_out] = Date.strptime(assign_param[:check_out], '%Y-%m-%d')
        assign_param[:user_id] = current_user.id
        reservation = Reservation.new(assign_param)

        # assign_param[:days] = (assign_param[:check_out] - assign_param[:check_in]).to_i
        # assign_param[:user_id] = current_user.id
        if reservation.save
            redirect_to new_reservation_payment_path(reservation.id)
        else
            flash[:notice] = reservation.errors.messages
            redirect_to listing_path(params[:listing_id])
        end


    end

    def edit

    end

    def update

    end

    def destroy

    end

    # action for email testing
    # def send_email
    #     reservation_id = 22
    #     ReservationJob.set(wait: 1.minute).perform_later reservation_id
    #     @listing = Reservation.find(22).listing
    #     render 'email_report'
    # end

    private

    def reservation_params
        params.require(:reservation).permit([:listing_id,:user_id, :check_in, :check_out, :num_of_guests])
    end

end
