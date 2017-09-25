class ReservationsController < ApplicationController

    before_action do
        # todo different routing for moderator, guest and host
        # moderator and guest should be redirected to reservation profile
        # host should be redirected to listing page
        not_sign_in_redirect url: listings_path, msg: 'Please sign in to perform this action'
    end

    before_action(except: [:index, :new, :create]) do
        # todo different routing for moderator, guest and host
        resource_exist? url: listings_path, resource: Reservation, resource_id: params[:id], msg: 'There is no such reservation'
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

    def index
        if current_user.moderator?
            @reservations = Reservation.all
        elsif params[:listing_id].nil?
        #     show reservations for guest
            @reservations = current_user.reservations
        elsif params[:listing_id]
        #     show reservations for host
            @reservations = current_user.listings.find(params[:listing_id])
        end
    end

    def show

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
        if !reservation.save
            flash[:notice] = reservation.errors.messages
        end

        redirect_to listing_path(params[:listing_id])

    end

    def edit

    end

    def update

    end

    def destroy

    end

    private

    def reservation_params
        params.require(:reservation).permit([:listing_id,:user_id, :check_in, :check_out, :num_of_guests])
    end

end
