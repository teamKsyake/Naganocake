class ItemOrder < ApplicationRecord
  has_one_attached :image
  belongs_to :item
  belongs_to :order

  enum production_status: { cannot_start: 0, pending_production: 1, in_production: 2, done: 3 }

  def subtotal_price
    (amount * price)
  end
end
