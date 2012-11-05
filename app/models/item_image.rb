# ==ItemImage model
# This model supports the images uploaded for an item.
#
# Note that an item can have many images, but an image can only be tagged to one item - Relationship: belongs_to :item.
#
# Other attributes of an image has also been included here.
#
class ItemImage < ActiveRecord::Base
  attr_accessible :asset

  #Relationships
  belongs_to :item

  has_attached_file :asset,
                    :styles => { :large => "640x480", :medium => "300x300>", :thumb => "100x100>" },
                    :url => "/assets/items/:id/:style/:basename.:extension",
                    :path => ":rails_root/public/assets/items/:id/:style/:basename.:extension"

  validates_attachment_size :asset, :less_than => 5.megabytes
  validates_attachment_content_type :asset, :content_type => ['image/jpeg','image/png']
end