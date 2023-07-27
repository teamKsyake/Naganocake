# app/controllers/public/orders_controller.rb
class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
    @order.cart_items = current_customer.cart_items # カート内の商品情報を@orderに関連付ける
  end

  def create
    @order = current_customer.orders.build(order_params)
    @order.postage = 800 # 送料を固定の800円にセット
    @order.total_amount = @order.calculate_total_amount # 合計金額をセット
    # 注文処理のロジックを追加
    if @order.save
          current_customer.cart_items.each do |cart_item|
          @item_order = ItemOrder.new
          @item_order.item_id = cart_item.item_id
          @item_order.amount = cart_item.amount
          @item_order.price = (cart_item.item.price*1.1).floor
          @item_order.order_id =  @order.id
          @item_order.save
        end

        current_customer.cart_items.destroy_all #カートの中身を削除
        redirect_to orders_complete_order_path
    else
      # 保存が失敗した場合の処理
      render :new
    end
  end

  def check
    # 注文情報確認ページ用のアクション
    @order = Order.new(order_params)
    @order.postage = 800 # 送料を固定の800円にセット
    if params[:order][:selection_address] == "0"
      @order.postcode = current_customer.postcode
      @order.address = current_customer.address
      @order.name = current_customer.full_name
    elsif params[:order][:selection_address] == "1"
      @shipping_address = ShippingAddress.find(params[:order][:shipping_address_id])
      @order.postcode = @shipping_address.postcode
      @order.address = @shipping_address.address
      @order.name = @shipping_address.delivery_name
    elsif params[:order][:selection_address] == "2"
      @order.postcode = params[:order][:postcode]
      @order.address = params[:order][:address]
      @order.name = params[:order][:name]
    end
    # カート内の商品の金額を合計する
    @order.total_amount = current_customer.cart_items.sum { |cart_item| cart_item.item.with_tax_price * cart_item.amount }
  end

  def complete_order
    # 注文を確定するアクション
    #@order = Order.find(params[:id])
    #@order.update(status: :completed)
    # 必要に応じて、支払い処理や在庫の管理などを行う
    #redirect_to order_path(@order)
  end

  def index
    # 注文履歴一覧などのアクション
    @orders = current_customer.orders
  end

  def show
    @order = Order.find(params[:id])
    @item_order = @order.item_orders
    @toral = 0
  end

  private

  def order_params
      params.require(:order).permit(:customer_id, :name, :postcode, :address, :postage, :total_amount, :payment_method, :status)
  end

  def confirmation
    @order = current_customer.orders.find(params[:id])
  end
end
