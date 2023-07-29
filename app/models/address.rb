class Address < ApplicationRecord
  belongs_to :customer

  validates :customer_id, :name, :address, presence: true
  validates :postcode, length: {is: 7}, numericality: { only_integer: true }
  validates :address, presence: true

  def order_address
    self.postcode + self.address + self.name
  end
end


