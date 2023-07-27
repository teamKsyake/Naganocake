# app/controllers/public/orders_controller.rb
class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
    @address = Address.new
  end

  def check
     @order = current_customer.orders.new(order_params)
     @order.postage = 800

     @item_total_price = 0
     current_customer.cart_items.each do |cart_item|
       subtotal_price = cart_item.item.price * cart_item.amount * 110 / 100
       @item_total_price += subtotal_price
     end
     @order.total_amount = @item_total_price + @order.postage

      if params[:order][:select_address] == "0"
        @order.postcode = current_customer.postcode
        @order.address = current_customer.address
        @order.name = "#{current_customer.last_name}#{current_customer.first_name}"
      elsif params[:order][:select_address] == "1"
        @address = Address.find(params[:address_id])
        @order.postcode = @address.postcode
        @order.address = @address.address
        @order.name = @address.name
      elsif params[:order][:select_address] == "2"
        @address = current_customer.address.new(address_params)
        if @address.valid?
          @order.postcode = @address.postcode
          @order.address = @address.address
          @order.name = @address.name
        else
          render 'new'
        end
      end



  # @order.payment = current_customer.cart_items.inject(0){|sum, cart_item| cart_item.subtotal_price + sum} + @order.postage
end

  def create
    @order = current_customer.orders.build(order_params)
    @order.postage = 800
    @cart_items=current_customer.cart_items
    # 注文処理のロジックを追加
    if @order.save
      # 保存が成功した場合の処理
      @cart_items.each do |cart_item|
        ItemOrder.create!(
          order_id:@order.id,item_id: cart_item.item_id,price:cart_item.item.with_tax_price,amount: cart_item.amount
          )
      end
      current_customer.cart_items.destroy_all
      redirect_to order_path(@order)
    else
      # 保存が失敗した場合の処理
      render :new
    end
  end

  def complete_order
    # 注文を確定するアクション
    @order = Order.find(params[:id])
    @order.update(status: :completed)
    # 必要に応じて、支払い処理や在庫の管理などを行う
    redirect_to order_path(@order)
  end

  def index
    # 注文履歴一覧などのアクション
    @orders = current_customer.orders
  end

  def show
    # 注文詳細ページなどのアクション
    @order = current_customer.orders.find(params[:id])
  end

  private

  def order_params
    params.require(:order).permit(:name, :postcode, :address, :postage, :total_amount, :payment_method)
  end

  def confirmation
    @order = current_customer.orders.find(params[:id])
  end
end
