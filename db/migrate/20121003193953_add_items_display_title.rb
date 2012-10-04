class AddItemsDisplayTitle < ActiveRecord::Migration
  def up
    add_column("items","display_title",:string)
  end

  def down
    remove_column("items","display_title")
  end
end
