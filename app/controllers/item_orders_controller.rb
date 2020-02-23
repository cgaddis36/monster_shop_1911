class ItemOrdersController < ApplicationController

  def update
    order = Order.find(params[:order_id])
    item_orders = order.item_orders.all
    item_orders.each do |itemorder|
      itemorder.update_attribute(:status = 1)
    end
    require "pry"; binding.pry
    order.cancel

  end



end
