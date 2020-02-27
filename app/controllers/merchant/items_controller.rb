# frozen_string_literal: true

class Merchant::ItemsController < Merchant::BaseController

  def index
    @merchant = Merchant.where("id = #{current_user.merchant.id}").first
  end

  def edit
    @item = if session[:failed_update]
              Item.find(session[:failed_update])
            else
              Item.find(params[:id])
            end
  end

  def update
    @item = Item.find(params[:id])
    if params[:item]
      update_item(@item)
    else
      @item.switch_active_status
      switch_active_with_flash(@item)
    end
  end

  def destroy
    item = Item.find(params[:id])
    destroy_item(item)
  end

  def new
    @item = if session[:failed_save]
              Item.new(session[:failed_save])
            else
              Item.new
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
      redirect_to '/merchant/items'
    else
      session[:failed_update] = params[:id]
      flash[:error] = @item.errors.full_messages.to_sentence
      redirect_to "/merchant/items/#{params[:id]}/edit"
    end
  end

  def switch_active_with_flash(item)
    flash[:success] = if item.active?
                        "#{item.name} is activated"
                      else
                        "#{item.name} is deactivated"
                      end
    redirect_to '/merchant/items'
  end

  def destroy_item(item)
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:notice] = "#{item.name} has been deleted"
    redirect_to '/merchant/items'
  end

  def create_item(item)
    @item = item
    if @item.save
      flash[:notice] = 'Your new item was saved'
      redirect_to '/merchant/items'
    else
      session[:failed_save] = item_params
      flash[:error] = @item.errors.full_messages.to_sentence
      redirect_to '/merchant/items/new'
    end
  end

  def item_params
    if params[:item]
      params.require('item').permit(:name, :price, :age, :description, :image, :inventory)
    else
      params.require('/merchant/items').permit(:name, :price, :age, :description, :image, :inventory)
    end
  end
end
