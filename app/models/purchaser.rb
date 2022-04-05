class Purchaser < ApplicationRecord
    has_many :orders
    has_many :books, through: :orders
    validates_presence_of :first_name, :last_name, :phone, :email
end
