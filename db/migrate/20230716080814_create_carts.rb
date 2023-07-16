class CreateCarts < ActiveRecord::Migration[6.1]
  def change
    create_table :carts do |t|
      # sessionで管理する場合user_idはnullになるのでnull: falseは不要
      t.references :carts, :user, foreign_key: true
      t.timestamps
    end
  end
end
