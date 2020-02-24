class Merchant::ItemsController < Merchant::BaseController 

  def index
    @merchant = Merchant.where("id = #{current_user.merchant.id}").first
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:notice] = "#{item.name} has been deleted"
    redirect_to "/merchant/items"
  end

end
