class Item < ActiveRecord::Base
  attr_accessible :bid_duration, :buy_price, :category_id, :description, :minimum_bid_price, :quantity, :title, :display_title

  # Relationships
  belongs_to :category

  # Functions
  # This is a search function, which queries the database for similar item titles
  scope :search_item_by_title, lambda {|query| where("title LIKE ?", "%#{query}%")}
end
