class CreateLeases < ActiveRecord::Migration[5.2]
  def change
    create_table :leases do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.belongs_to :property_document, index: true, foreign_key: true

      t.timestamps
    end

    create_table :leases_tenants do |t|
      t.belongs_to :lease, index: true
      t.belongs_to :tenant, index: true
    end
  end
end
