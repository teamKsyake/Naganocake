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
    if order.status == "入金確認"
      order.order_items.each do |order_item|
        order_item.update(item_status: "製作待ち")
      end
    end
    flash[:notice] = "You have updated status successfully."
      redirect_to admin_order_path(order.id)
  end

  def show
    @order = Order.find(params[:id])
    @item_orders = @order.item_orders
  end

  private
  
  def order_params
    params.require(:order).permit(:name, :postcode, :address, :postage, :total_amount, :payment_method, :status)
  end
end
