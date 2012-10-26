class Category < ActiveRecord::Base
  attr_accessible :title

  # Relationships
  has_one :item
end
