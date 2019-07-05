class RemoveAddressFromTenant < ActiveRecord::Migration[5.2]
  def change
    remove_column :tenants, :address
  end
end
