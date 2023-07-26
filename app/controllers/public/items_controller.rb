class Public::ItemsController < ApplicationController
  def index
    @items = Item.all.page(params[:page]).per(8)
  end

  def show
    @item = Item.find(params[:id])
    @cart_item = CartItem
  end

  private
  def item_params
    params.require(:item).permit(:name, :image, :price)
  end

  def cart_item_params
    params.require(:cart_item).permit(:costomer_id, :item_id, :amount)
  end
end
