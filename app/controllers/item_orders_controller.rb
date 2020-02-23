class ItemOrdersController < ApplicationController

  def update
    order = Order.find(params[:order_id])
    item_orders = order.item_orders.all
    item_orders.each do |itemorder|
      itemorder.update(status: 0)
      Item.find(itemorder.id).increment(:inventory, itemorder.quantity).save
    end
    order.update(status: 3)
    flash[:alert] = "Your order has been cancelled."
    redirect_to '/profile'
  end



end
