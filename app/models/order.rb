class Order < ApplicationRecord
  belongs_to :book
  belongs_to :purchaser
  has_many :addresses
  accepts_nested_attributes_for :addresses
  accepts_nested_attributes_for :purchaser
  validates_presence_of :quantity
  
end
