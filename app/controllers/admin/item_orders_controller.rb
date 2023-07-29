class Admin::ItemOrdersController < ApplicationController
  before_action :authenticate_admin!
  def update

    @item_order = ItemOrder.find(params[:id])
    @item_order.update(item_order_params)
    @order = @item_order.order


    # 製作ステータスを「製作中（２）」→注文ステータスを「製作中（２）」
    if @item_order.production_status == "in_production"
      @order.update(status: 2)
      flash[:notice] = "製作ステータスの更新をしました。"
      @order.save
    end

    # 注文個数と製作完了になっている個数が同じならば
    if @order.item_orders.count == @order.item_orders.where(production_status: 3).count
      @order.update(status: 3)
      flash[:notice] = "製作ステータスの更新をしました。"
      @order.save
    end

    redirect_to request.referer
  end

  private

  def item_order_params
    params.require(:item_order).permit(:order_id, :production_status, :amount, :order_id)

  end
end
