class CreateInsuranceDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :insurance_documents do |t|
      t.references :property, null: false, foreign_key: true
      t.string :title, null: false

      t.timestamps
    end
  end
end
