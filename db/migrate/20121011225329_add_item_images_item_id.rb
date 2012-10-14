class AddItemImagesItemId < ActiveRecord::Migration
  def up
    add_column("item_images","item_id",:integer)
  end

  def down
    remove_column("item_images","item_id")
  end
end
