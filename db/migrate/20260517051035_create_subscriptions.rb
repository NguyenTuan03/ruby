class CreateSubscriptions < ActiveRecord::Migration[8.1]
  def change
    create_table :subscriptions do |t|
      t.references :product, null: false, foreign_key: true
      t.references :subscriber, null: false, foreign_key: true

      t.timestamps
    end
    # Đảm bảo một subscriber không thể đăng ký trùng lặp một sản phẩm 2 lần
    add_index :subscriptions, [:product_id, :subscriber_id], unique: true
  end
end
