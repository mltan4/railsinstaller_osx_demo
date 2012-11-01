class AddItemsCurrentBid < ActiveRecord::Migration
  def up
    add_column("items","current_bid",:integer,:default => 0)
  end

  def down
    remove_column("items","current_bid")
  end
end
