class Admin::ItemsController < Admin::BaseController
  def index
    @merchant = Merchant.find(params[:merchant_id])
  end

  def update
    @merchant.find(params[:merchant_id])
    @item = Item.find(params[:id])
    if params[:commit]
      @item.update(item_params)
      give_default_image_if_needed(@item)
      edit_item_info(@item, @merchant)
    else
      @item.switch_active_status
      switch_active_with_flash(@item, @merchant)
    end
  end

  def destroy
    merchant = Merchant.find(params[:merchant_id])
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:notice] = "#{item.name} has been deleted"
    redirect_to "/admin/merchants/items"
  end

  def switch_active_with_flash(item, merchant)
    if item.active?
      flash[:success] = "#{item.name} is activated"
    else
      flash[:success] = "#{item.name} is deactivated"
    end
    redirect_to "/admin/merchants/items"
  end

end
