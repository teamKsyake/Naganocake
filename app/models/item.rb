class Item < ApplicationRecord
  has_one_attached :image
  enum is_available: { stop: false, sale: true }
end
