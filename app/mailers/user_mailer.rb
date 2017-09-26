class UserMailer < ApplicationMailer
    default from: 'pairbnb.challenge@gmail.com'

    # Subject can be set in your I18n file at config/locales/en.yml
    # with the following lookup:
    #
    #   en.user_mailer.reservation_confirmation.subject
    #
    def reservation_confirmation(reservation)
        @reservation = reservation
        @greeting = "Hi"

        mail to: "khun84@gmail.com", subject: "Reservation confirmation"
    end
end
