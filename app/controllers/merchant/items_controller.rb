class Merchant::ItemsController < Merchant::BaseController
  def new
    @item = Item.new
  end

  def index
    @merchant = Merchant.where("id = #{current_user.merchant.id}").first
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

  def update
    @item = Item.find(params[:id])
    @item.switch_active_status
    switch_active_with_flash(@item)
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:notice] = "#{item.name} has been deleted"
    redirect_to "/merchant/items"
  end

  private

  def switch_active_with_flash(item)
    if item.active?
      flash[:success] = "#{item.name} is activated"
    else
      flash[:success] = "#{item.name} is deactivated"
    end
    redirect_to '/merchant/items'
  end

  def item_params
    params.require("/merchant/items").permit(:name, :price, :age, :description, :image, :inventory)
  end

end
