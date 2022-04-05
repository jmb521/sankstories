class Address < ApplicationRecord
  belongs_to :order
  validates_presence_of :address_1, :city, :state, :zipcode
end
