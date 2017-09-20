class AddVerifiedColumnToListing < ActiveRecord::Migration[5.1]
  def change
      add_column :listings, :verified, :boolean
  end
end
