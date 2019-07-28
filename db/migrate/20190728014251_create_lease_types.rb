class CreateLeaseTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :lease_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
