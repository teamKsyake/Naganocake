class Order < ApplicationRecord
  belongs_to :customer
  has_many :item_orders, dependent: :destroy
  
  validates :postcode, length: {is: 7}, numericality: { only_integer: true }


  enum payment_method: { credit_card: 0, transfer: 1 }

  enum status: { awaiting_payment: 0, confirmed_payment: 1, in_production: 2, preparing_to_ship: 3, done: 4 }

  has_many :cart_items
  # カート内の商品との関連を定義する

 def calculate_total_amount
    # カート内の商品の金額を合計する
    cart_total = cart_items.sum { |item| item.product.price * item.quantity }

    # 送料を合計金額に加算する
    total_amount = cart_total + self.postage

    total_amount
 end


  # 注文商品の個数小計
  def total_count
    total = 0
    order_items.each do |prder_item|
      total += order_item.count
    end
    total
  end


  # 注文商品の合計金額
  def item_sum
    total = 0
    item_orders.each do |item_order|
      total += item_order.subtotal_price
    end
    total
  end


  # 請求金額合計（送料込み）
  def total_price
    total = 0
    item_orders.each do |item_order|
      total += item_order.subtotal_price
    end
    total + postage
  end

  def address_display
    "〒"+postcode+address+name
  end
  # 郵便番号（ハイフンあり７桁）
  # VALID_ZIP_CODE = /\A/\d{3}[-]\d{4}\z
  # with_options presence: true do
  #   validates :zip_code, format: {
  #     with: VALID_ZIP_CODE,
  #     message: "はハイフンあり７桁で入力してください。"
  #   }

  #   varidates :delivery_address, length: {minimum: 2, maximum: 50}
  #   validates :delivery_name, length: {minimum: 1}
  # end

end