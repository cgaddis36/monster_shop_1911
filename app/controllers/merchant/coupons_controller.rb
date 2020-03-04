class Merchant::CouponsController < Merchant::BaseController
  def new
    @coupon = Coupon.new
  end
  def index
    @coupons = Coupon.all
    @merchant = current_user.merchant
  end
  def show
    @coupon = Coupon.find(params[:id])
  end
  def create
    merchant = Merchant.find(current_user.merchant.id)
    coupon = merchant.coupons.new(coupon_params)
    if coupon.save
      flash[:success] = 'Coupon has been created!'
      redirect_to '/merchant/coupons'
    else
      flash[:error] = coupon.errors.full_messages.to_sentence
      render :new
    end
  end
  def edit
    @coupon = Coupon.find(params[:id])
  end
  def update
    coupon = Coupon.find(params[:id])
    if coupon.update(coupon_params)
      flash[:success] = 'Coupon Updated'
      redirect_to "/merchant/coupons/#{coupon.id}"
    else
      flash[:error] = coupon.errors.full_messages.to_sentence
      redirect_to "/merchant/coupons/#{coupon.id}/edit"
    end
  end
  def destroy
    coupon = Coupon.find(params[:id])
    if Order.find_by(coupon_id: params[:id]) != nil
      flash[:error] = "#{coupon.name} has been used in an order"
      redirect_to "/merchant/coupons/#{coupon.id}"
    else
      flash[:success] = "Coupon has been deleted"
      coupon.destroy
      redirect_to "/merchant/coupons"
    end
  end

private
  def coupon_params
    params.permit(:name, :value, :item_quantity)
  end
end
