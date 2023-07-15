class CreateSends < ActiveRecord::Migration[6.1]
  def change
    create_table :sends do |t|

      t.timestamps
    end
  end
end
