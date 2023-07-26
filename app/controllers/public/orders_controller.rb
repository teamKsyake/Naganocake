# app/controllers/public/orders_controller.rb
class Public::OrdersController < ApplicationController
  def new
    @order = Order.new
  end

  def create
    @order = current_customer.orders.build(order_params)
    # 注文処理のロジックを追加
    if @order.save
      # 保存が成功した場合の処理
      redirect_to order_path(@order)
    else
      # 保存が失敗した場合の処理
      render :new
    end
  end

  def check
    # 注文情報確認ページ用のアクション
    @order = Order.find(params[:id])
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
