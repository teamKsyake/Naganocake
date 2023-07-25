class Public::CartItemsController < ApplicationController
  before_action :authenticate_customer!

  def index
    @customer = Customer.find(current_customer.id)
  end

  def create
    @cart_item = current_customer.cart_items.new(cart_item_params)
    if @cart_item.save
      redirect_to cart_items_path
    end
  end

  def update
    @cart_item = CartItem.find(params[:id])
    @cart_item.update!(cart_item_params)
    @customer = Customer.find(current_customer.id)
    render :index
  end

  def destroy
    cart_item = CartItem.find(params[:id])
    if cart_item.destroy
      flash[:notice] ="カート内の商品を空にしました"
      redirect_to cart_items_path
    else
      render action: :index
    end
  end

  def destroy_all
    customer = Customer.find(current_customer.id)
    if customer.cart_items.destroy_all
      flash[:notice] = "カート内の商品を全て削除しました"
      redirect_to cart_items_path
    else
      render action: :index
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:amount,:item_id)
  end
end