class CreateSales < ActiveRecord::Migration
  def change
    create_table :sales do |t|
      t.integer :user_id
      t.integer :store_id
      t.integer :issue_id
      t.integer :drop_qty, default: 0
      t.integer :pick_qty, default: 0

      t.timestamps null: false
    end
  end
end
