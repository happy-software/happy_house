class CreateLeases < ActiveRecord::Migration[5.2]
  def change
    create_table :leases do |t|
      t.datetime :start_date
      t.datetime :end_date
      t.jsonb :details
      t.belongs_to :property_document, index: true, foreign_key: true

      t.timestamps
    end
  end
end
