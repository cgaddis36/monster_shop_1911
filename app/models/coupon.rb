class Coupon < ApplicationRecord
  validates_presence_of :name, :item_quantity
  validates_inclusion_of :value, in: 0..100, message: "must be between 0 and 100."

  belongs_to :merchant
  has_many :orders
end
