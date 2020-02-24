class ItemOrdersController < ApplicationController

  def update
    order = Order.find(params[:order_id])
    item_orders = order.item_orders.all
    item_orders.each do |itemorder|
      if itemorder.status == "fulfilled"
        Item.find(itemorder.item_id).increment(:inventory, itemorder.quantity).save
        itemorder.update(status: "unfulfilled")
      end
    end
    order.update(status: 3)
    flash[:alert] = "Your order has been cancelled."
    redirect_to '/profile'
  end
end