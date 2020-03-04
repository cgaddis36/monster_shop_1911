class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def add_quantity(item_id)
    @contents[item_id] += 1
  end

  def subtract_quantity(item_id)
    @contents[item_id] -= 1
  end

  def quantity_zero?(item_id)
    @contents[item_id] == 0
  end

  def limit_reached?(item_id)
    item = Item.find(item_id)
    @contents[item_id] == item.inventory
  end

  def regular_subtotal(item)
    item.price * @contents[item.id.to_s]
  end

  def subtotal(item)
    merchant = Merchant.find(item.merchant_id)
    number_ordered = @contents[item.id.to_s]
    best_coupon = merchant.coupons.where("coupons.item_quantity <= ?", number_ordered).first
    regular_price = item.price * @contents[item.id.to_s]
    if best_coupon != nil
      discount = (100 - best_coupon.value) / 100
      regular_price * discount
    else
      regular_price
    end
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end
  
  def find_coupon(item)
    merchant = Merchant.find(item.merchant_id)
    number_ordered = @contents[item.id.to_s]
    best_coupon = merchant.coupons.where("coupons.item_quantity <= ?", number_ordered).first
  end
end
