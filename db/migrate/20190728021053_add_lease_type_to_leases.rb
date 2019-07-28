class AddLeaseTypeToLeases < ActiveRecord::Migration[5.2]
  def change
    add_reference :leases, :lease_type, index: true
  end
end
