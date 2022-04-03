class Book < ApplicationRecord
    has_many :orders
    has_many :purchasers, through: :orders
end
