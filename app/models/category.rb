# ==Category model
# Model to define categories
#
# Relationships: has_one :item
class Category < ActiveRecord::Base
  attr_accessible :title

  # Relationships
  has_one :item
end
