class UserMailer < ApplicationMailer
    default from: 'pairbnb.challenge@gmail.com'

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.user_mailer.reservation_confirmation.subject
    #
    def reservation_confirmation(reservation)
        @reservation = reservation
        # change this to guest email
        email = 'khun84@gmail.com'
        mail to: email, subject: "Pairbnb: Reservation confirmation"
    end
end
