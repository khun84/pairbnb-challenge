class CreateLocationsTable < ActiveRecord::Migration[5.1]
  def change
    create_table :locations do |t|
        t.timestamp
        t.string :country
        t.string :state
        t.string :city
    end
  end
end
