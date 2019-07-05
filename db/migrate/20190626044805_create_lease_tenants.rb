class CreateLeaseTenants < ActiveRecord::Migration[5.2]
  def change
    create_table :lease_tenants do |t|
      t.references :tenant, foreign_key: true
      t.references :lease, foreign_key: true

      t.timestamps
    end
  end
end
