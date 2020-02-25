class Merchant::OrdersController < Merchant::BaseController

  def show
    @orders = Order.all
  end
end
