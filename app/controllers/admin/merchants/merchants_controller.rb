class Admin::MerchantsController < Admin::BaseController

  def index
    @merchants = Merchant.all
  end

  def show
    @merchant = Merchant.find(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant.change_status
    if merchant.enabled?
      flash[:notice] = "#{merchant.name} is enabled."
    else merchant.disabled?
      flash[:notice] = "#{merchant.name} is disabled."
    end
    redirect_to '/admin/merchants'
  end
end
