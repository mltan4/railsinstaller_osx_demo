# Category model
# Supports the categories for an item
# Relationships:
#   has_one :item
class Category < ActiveRecord::Base
  attr_accessible :title

  # Relationships
  has_one :item
end
