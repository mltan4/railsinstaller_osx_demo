class AddItemsCurrentBidderId < ActiveRecord::Migration
  def up
    add_column("items","current_bidder_id",:integer,:default => 0)
  end

  def down
    remove_column("items","current_bidder_id")
  end
end
