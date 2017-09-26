class ReservationJob < ApplicationJob
  queue_as :default

  def perform(reservation_id)
    # Do something later
      UserMailer.reservation_confirmation(reservation_id).deliver_now
  end
end