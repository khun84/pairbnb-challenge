class AddPriceAndNumberOfGuestToReservation < ActiveRecord::Migration[5.1]
  def change
      add_column :reservations, :price, :numeric
      add_column :reservations, :num_of_guests, :integer
  end
end
