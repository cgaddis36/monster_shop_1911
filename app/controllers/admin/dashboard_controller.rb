class Admin::DashboardController < Admin::BaseController

  def index
    @orders = Order.all.status_sort
  end


end
