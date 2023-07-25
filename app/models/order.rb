class Order < ApplicationRecord
  enum payment_method: { クレジットカード: 0, 銀行振込: 1 }
  enum status: { new_order: 0, checked: 1, completed: 2 }
end