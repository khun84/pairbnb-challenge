class PaymentsController < ApplicationController
    def new
        @reservation = Reservation.find(params[:reservation_id])
        @client_token = Braintree::ClientToken.generate
    end

    def checkout

        # check availability
        reservation = Reservation.find(params[:reservation_id])
        if !reservation.available_to_book?
            flash[:notice] = 'The requested date has been booked. Please try other date.'
            reservation.destroy
            return redirect_to listing_path(reservation.listing_id)
        end

        nonce_from_the_client = params[:checkout_form][:payment_method_nonce]

        result = Braintree::Transaction.sale(
                :amount => reservation.price,
                :payment_method_nonce => nonce_from_the_client,
                :options => {
                        :submit_for_settlement => true
                }
        )

        if result.success?
            UserMailer.reservation_confirmation(reservation).deliver_now
            redirect_to reservations_path, :flash => { :notice => "Transaction successful!" }
        else
            # todo handle payment failure
            redirect_to listing_path(reservation.listing_id), :flash => { :notice => "Transaction failed. Please try again." }
        end
    end
end
