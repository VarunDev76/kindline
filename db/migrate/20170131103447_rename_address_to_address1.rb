class RenameAddressToAddress1 < ActiveRecord::Migration
  def change
  	rename_column :stores, :address, :address_1
  end
end
