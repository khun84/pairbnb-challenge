class NormalizeLocationInListing < ActiveRecord::Migration[5.1]
  def change
      remove_column :listings, :country, :string
      remove_column :listings, :state, :string
      remove_column :listings, :city, :string

      add_reference :listings, :location, foreign_key: true
  end
end
