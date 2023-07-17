class CreateItemOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :item_orders do |t|
       t.integer :item_id, null: false
       t.integer :order_id, null: false
       t.integer :price, null: false
       t.integer :production_status, null: false, default: 0
       t.integer :amount, null: false

      t.timestamps
    end
  end
end
