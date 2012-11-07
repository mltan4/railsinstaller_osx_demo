# ==Item model
# This model define the relationships, attributes, and functions for each item.
#
# An item can only belong to one user & category - Relationship: belongs_to :user and belongs_to :category.
#
# This section accepts_nested_attributes_for :item_images and :allow_destroy => true.
#
# Here are the status codes for search function:
#
# 1 - Active,
#
# 2 - Sold (Buy Now option),
#
# 3 - Sold (Bids),
#
# 4 - Expired (No Bids),
#
# 9 - Cancelled
#
# This also calls for a search function which queries the database for similar item titles.

class Item < ActiveRecord::Base
  attr_accessible :bid_duration, :buy_price, :category_id, :description, :minimum_bid_price, :quantity, :title, :display_title, :item_images_attributes, :current_bidder_id
  validates_presence_of :display_title, :category_id, :description, :quantity

  # Relationships
  has_many :item_images
  belongs_to :user
  belongs_to :category
  accepts_nested_attributes_for :item_images, :allow_destroy => true

  scope :search_item_by_title, lambda {|query, status| where("status = ?", "#{status}").where("title LIKE ?", "%#{query}%")}
end
