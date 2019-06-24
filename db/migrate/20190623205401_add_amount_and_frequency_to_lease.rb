class AddAmountAndFrequencyToLease < ActiveRecord::Migration[5.2]
  def change
    add_column :leases, :amount, :decimal
    add_reference :leases, :lease_frequency, index: true
  end
end
