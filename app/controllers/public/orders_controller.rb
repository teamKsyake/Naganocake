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
      # 保存が成功した場合の処理
      redirect_to orders_check_path # 注文情報確認画面にリダイレクトする
    else
      # 保存が失敗した場合の処理
      render :new
    end
  end

  def check
    # 注文情報確認ページ用のアクション
    @order = Order.new(order_params)
    @order.postage = 800 # 送料を固定の800円にセット
    @order.postcode = current_customer.postcode
    @order.address = current_customer.address
    @order.name = current_customer.first_name + current_customer.last_name
    # カート内の商品の金額を合計する
    @order.total_amount = current_customer.cart_items.sum { |cart_item| cart_item.item.with_tax_price * cart_item.amount }
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
    @order = current_customer.orders
  end

  private

  def order_params
    params.require(:order).permit(:name, :postcode, :address, :postage, :total_amount, :payment_method)
  end

  def confirmation
    @order = current_customer.orders.find(params[:id])
  end
end
