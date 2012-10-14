class Item < ActiveRecord::Base
  attr_accessible :bid_duration, :buy_price, :category_id, :description, :minimum_bid_price, :quantity, :title, :display_title, :item_images_attributes

  # Relationships
  has_many :item_images
  accepts_nested_attributes_for :item_images, :allow_destroy => true

  # Functions
  scope :search_item_by_title, lambda {|query| where("title LIKE ?", "%#{query}%")}
end
