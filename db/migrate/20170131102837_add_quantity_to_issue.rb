class AddQuantityToIssue < ActiveRecord::Migration
  def change
    add_column :issues, :quantity, :integer, default: 0
    add_column :issues, :amount, :integer, default: 0
  end
end
