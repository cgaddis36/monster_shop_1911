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

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:notice] = "#{item.name} has been deleted"
    redirect_to "/merchant/items"
  end

  def new
    if session[:failed_save]
      @item = Item.new(session[:failed_save])
    else   
      @item = Item.new 
    end
  end

  def create
    merchant = Merchant.where("id = #{current_user.merchant.id}").first
    @item = merchant.items.create(item_params)
    if @item.save
      flash[:notice] = 'Your new item was saved'
      redirect_to "/merchant/items"
    else
      session[:failed_save] = item_params
      flash[:error] = @item.errors.full_messages.to_sentence
      redirect_to "/merchant/items/new"
    end
  end
  
  private 
  
  def item_params
    params.require(:item).permit(:name, :price, :age, :description, :image, :inventory)
  end

end
