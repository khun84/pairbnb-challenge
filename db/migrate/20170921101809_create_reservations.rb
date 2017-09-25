class CreateReservations < ActiveRecord::Migration[5.1]
    def change
        create_table :reservations do |t|
            t.timestamps
            t.references :user
            t.references :listing
            t.date :check_in
            t.date :check_out
            t.integer :days
            t.integer :status, default: 1
        end
    end
end
