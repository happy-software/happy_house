class CreateMortgageStatements < ActiveRecord::Migration[7.0]
  def change
    create_table :mortgage_statements do |t|
      t.references :property, null: false, foreign_key: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
