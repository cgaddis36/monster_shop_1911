class Order < ApplicationRecord
  validates_presence_of :name, :address, :city, :state, :zip

  has_many :item_orders
  has_many :items, through: :item_orders

  belongs_to :user
  belongs_to :coupon, optional: true

  enum status: %w[pending packaged shipped cancelled]

  def grandtotal
    grand_total = 0
    item_orders.each do |item_order|
      item = Item.find(item_order.item_id)
      merchant = Merchant.find(item.merchant_id)
      number_ordered = item_order.quantity
      best_coupon = merchant.coupons.where("coupons.item_quantity <= ?", number_ordered).first
      if best_coupon != nil
        regular_price = item.price * item_order.quantity
        discount = (100 - best_coupon.value) / 100
        new_cost = regular_price * discount
        grand_total += new_cost
      else
        reg_cost = item_order.price * item_order.quantity
        grand_total += reg_cost
      end
    end
    grand_total
  end

  def total_quantity
    items.sum(:quantity)
  end

  def item_quantity_merchant(merchant)
    items.where(merchant: merchant).sum('item_orders.quantity')
  end

  def item_total_merchant(merchant)
    items.where(merchant: merchant).sum("item_orders.quantity * item_orders.price")
  end

  def status_changer
    if item_orders.all? { |itemorder| itemorder.status == 'fulfilled' }
      update(status: 'packaged')
    end
  end

  def self.pending_status
    all.where(status: "pending")
  end

  def self.packaged_status
    all.where(status: "packaged")
  end

  def self.shipped_status
    all.where(status: "shipped")
  end

  def self.cancelled_status
    self.all.where(status: "cancelled")
  end
end
