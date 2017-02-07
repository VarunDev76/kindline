class AddCurrentIssueDropToStore < ActiveRecord::Migration
  def change
    add_column :stores, :current_issue_id, :integer
    add_column :stores, :drop_qty, :integer, default: 0
    add_column :stores, :pick_qty, :integer, default: 0
  end
end
