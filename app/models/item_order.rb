class ItemOrder <ApplicationRecord
  validates_presence_of :item_id, :order_id, :price, :quantity

  belongs_to :item
  belongs_to :order

  enum status: %w(unfulfilled fulfilled)

  def subtotal
    grand_total = 0
    merchant = Merchant.find(item.merchant_id)
    number_ordered = quantity
    best_coupon = merchant.coupons.where("coupons.item_quantity <= ?", number_ordered).first
    if best_coupon != nil
      regular_price = item.price * quantity
      discount = (100 - best_coupon.value) / 100
      new_cost = regular_price * discount
      grand_total += new_cost
    else
      reg_cost = item.price * quantity
      grand_total += reg_cost
    end
    grand_total
  end
end
