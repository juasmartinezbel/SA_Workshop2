class CreateSales < ActiveRecord::Migration[5.1]
  def change
    create_table :sales do |t|
      t.integer :product_id
      t.integer :user_id

      t.timestamps
    end
  end
end
