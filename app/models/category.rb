# ==Category model
# This model defines categories for each item.
#
# An item can only belong to one category - Relationship: has_one :item.
#
# For Bestbay, here are the pre-defined categories:
#
# Mobile Phones, Laptops, Tablet, Computer Accessories, Home Electronics,
#
# Ladies Bags, Bag Packs, Clothes, Sports, Books, Games, Others.


class Category < ActiveRecord::Base
  attr_accessible :title

  # Relationships
  has_one :item
end
