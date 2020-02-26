class Merchant::ItemsController < Merchant::BaseController 

  def index
    @merchant = Merchant.where("id = #{current_user.merchant.id}").first
  end

  def edit
    if session[:failed_update]
      @item = Item.find(session[:failed_update])
    else
      @item = Item.find(params[:id])
    end 
  end

  def update
    @item = Item.find(params[:id])
    update_item(@item)
  end

  def destroy
    item = Item.find(params[:id])
    destroy_item(item)
  end

  def new
    if session[:failed_save]
      @item = Item.new(session[:failed_save])
    else   
      @item = Item.new 
    end
  end

  def create
    merchant = Merchant.find(current_user.merchant.id)
    @item = merchant.items.create(item_params)
    create_item(@item)
  end
  
  private 
  
  def item_params
    params.require(:item).permit(:name, :price, :age, :description, :image, :inventory)
  end

  def update_item(item)
    @item = item
    @item.update(item_params)
    if @item.save
      flash[:notice] = 'Your item was updated successfully'
      redirect_to "/merchant/items"
    else
      session[:failed_update] = params[:id]
      flash[:error] = @item.errors.full_messages.to_sentence
      redirect_to "/merchant/items/#{params[:id]}/edit"
    end
  end

  def destroy_item(item)
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:notice] = "#{item.name} has been deleted"
    redirect_to "/merchant/items"
  end

  def create_item(item)
    @item = item
    if @item.save
      flash[:notice] = 'Your new item was saved'
      redirect_to "/merchant/items"
    else
      session[:failed_save] = item_params
      flash[:error] = @item.errors.full_messages.to_sentence
      redirect_to "/merchant/items/new"
    end
  end

end
