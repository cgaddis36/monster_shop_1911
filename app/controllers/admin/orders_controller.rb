class Admin::OrdersController < Admin::BaseController

  def update
    order = Order.find(params[:order_id])
    if params[:status_change]  == "ship"
      order.update_column(:status, "shipped")
      flash[:alert] = "The order has been shipped."
    end
    redirect_to "/admin"
  end

  def show
    @order = Order.find(params[:order_id])
  end
end
