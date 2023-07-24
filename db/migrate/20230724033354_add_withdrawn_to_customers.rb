class AddWithdrawnToCustomers < ActiveRecord::Migration[6.0]
  def change
    add_column :customers, :withdrawn, :boolean, default: false
  end
end