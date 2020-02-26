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

  def new
    @item = Item.new 
  end

  def create
    merchant = Merchant.where("id = #{current_user.merchant.id}").first
    @item = merchant.items.create(item_params)
    if @item.save
      flash[:notice] = 'Your new item was saved'
      redirect_to "/merchant/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end
  
  private 
  
  def item_params
    params.require("/merchant/items").permit(:name, :price, :age, :description, :image, :inventory)
  end

end
