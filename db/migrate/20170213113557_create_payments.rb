class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :store_id
      t.string :transaction_id
      t.string :amount
      t.string :sale_id

      t.timestamps null: false
    end
  end
end
