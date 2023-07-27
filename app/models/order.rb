class Order < ApplicationRecord
  has_many :item_orders, dependent: :destroy
  belongs_to :customer

  enum payment_method: { クレジットカード: 0, 銀行振込: 1 }
  enum status: { new_order: 0, checked: 1, completed: 2 }

  has_many :cart_items
  # カート内の商品との関連を定義する

 def calculate_total_amount
    # カート内の商品の金額を合計する
    cart_total = cart_items.sum { |item| item.product.price * item.quantity }

    # 送料を合計金額に加算する
    total_amount = cart_total + self.postage

    total_amount
 end

  # 注文ステータス
  enum status: {"入金待ち" =>0, "入金確認" =>1, "制作中" =>2, "発送準備中" =>3, "発送済み" =>4}

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
    order_items.each do |order_item|
      total += order_item.subtotal_price
    end
    total
  end


  # 請求金額合計（送料込み）
  def total_price
    total = 0
    order_items.each do |order_item|
      total += order_item.subtotal_price
    end
    total + postage
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