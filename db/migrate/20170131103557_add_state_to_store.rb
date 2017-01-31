class AddStateToStore < ActiveRecord::Migration
  def change
    add_column :stores, :address_2, :string
    add_column :stores, :city, :string
    add_column :stores, :state, :string
    add_column :stores, :zip, :string
  end
end
