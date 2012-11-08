# ==User model
# This is the model to define the relationships, attributes, and functions for a specific user.
#
# This includes the default devise modules to implement authentication, validation and tracking.
#
# Here, setup of accessible or protected attributes can also be found.
#
# Note that a user can have many items and this is defined by Relationships: has_many :items

class User < ActiveRecord::Base

  # :token_authenticatable,
  # :lockable, :timeoutable and :omniauthable, :confirmable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Relationships
  has_many :items

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :username, :password, :password_confirmation, :remember_me
  # attr_accessible :title, :body
end
