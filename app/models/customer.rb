class Customer < ApplicationRecord
  has_one_attached :image
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :addresses, dependent: :destroy
  has_many :cart_items, dependent: :destroy
  has_many :orders, dependent: :destroy

  def full_name
    last_name + '' + first_name
  end

  def full_name_kana
    last_name_kana + '' + first_name_kana
  end

  def customer_status
    if is_withdrawal == true
      "退会"
    else
      "有効"
    end
  end

  def active_for_authentication?
    super && (is_withdrawal == false)
  end


  # カート内商品合計金額
  def cart_item_sum
    total = 0
    cart_items.each do |cart_item|
      total += cart_item.subtotal_price
    end
    total
  end

  # カート内商品合計個数
  def cart_total_count
    count = 0
    cart_items.each do |cart_item|
      count += cart_item.count
    end
    count
  end
end