class AddAttachmentAssetToItemImages < ActiveRecord::Migration
  def self.up
    change_table :item_images do |t|
      t.has_attached_file :asset
    end
  end

  def self.down
    drop_attached_file :item_images, :asset
  end
end
