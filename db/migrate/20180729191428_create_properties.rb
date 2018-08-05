class CreateProperties < ActiveRecord::Migration[5.2]
  def change
    create_table :properties do |t|
      t.hstore :address
      t.string :type

      t.timestamps
    end
  end
end
