class Item < ActiveRecord::Base
  attr_accessible :bid_duration, :buy_price, :category_id, :description, :minimum_bid_price, :quantity, :title, :display_title, :item_images_attributes, :current_bidder_id

  # Relationships
  has_many :item_images
  belongs_to :user
  belongs_to :category
  accepts_nested_attributes_for :item_images, :allow_destroy => true

  # Functions
  # This is a search function, which queries the database for similar item titles
  scope :search_item_by_title, lambda {|query| where("title LIKE ?", "%#{query}%")}
end
