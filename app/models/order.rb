class Order < ApplicationRecord
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
end