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
      render :edit
    end
  end 

private
  def coupon_params
    params.permit(:name, :value, :item_quantity)
  end
end
