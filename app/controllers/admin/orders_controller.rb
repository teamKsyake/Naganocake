class Admin::OrdersController < ApplicationController
  def index
    request_referer = Rails.application.routes.recognize_path(request.referer)
    request_referer_controller = request_referer[:controller]
    request_referer_action = request_referer[:action]

    if request_referer_controller == "admin/homes" && request_referer_action == "top"
      @order = Order.where("created_at >= ?", Date.today).page(params[:page]).reverse_order
    elsif request_referer_controller == "admin/customers" && request_referer_action == "show"
      @orders = Order.where('customer_id = ?', request_referer[:id]).page(params[:page]).reverse_order
    else
      @orders = Order.page(params[:page]).reverse_order
    end
  end

  def update
    order = Order.find(params[:id])
    order.update(order_params)
    order = Order.find(params[:id])
    # 注文ステータス[入金確認]=>製作ステータス[製作待ち]
    if order.status == "confirmed_payment"
      order.item_orders.each do |order_item|
        order_item.update(production_status: "pending_production")
      end
    end
    flash[:notice] = "You have updated status successfully."
      redirect_to admin_order_path(order.id)
    
  end

  def show
    @order = Order.find(params[:id])
    @item_order = @order.item_orders
  end

    private

    def order_params
      params.require(:order).permit(:status)
    end
end
