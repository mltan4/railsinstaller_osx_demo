class AddItemsSellerId < ActiveRecord::Migration
  def up
    add_column("items","seller_id",:integer,:default => 0)
  end

  def down
    remove_column("items","seller_id")
  end
end
