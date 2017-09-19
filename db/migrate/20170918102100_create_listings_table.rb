class CreateListingsTable < ActiveRecord::Migration[5.1]
    def change
        create_table :listings do |t|
            t.timestamps null: false
            t.string :name
            t.integer :room_count
            t.string :smoke
            t.string :country
            t.string :state
            t.string :city
            t.integer :person_count
            t.numeric :base_price
            t.references :user, foreign_key:true
            t.string :pet
        end
    end
end
