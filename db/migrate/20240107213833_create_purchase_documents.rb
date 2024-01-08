class CreatePurchaseDocuments < ActiveRecord::Migration[7.0]
  def change
    create_table :purchase_documents do |t|
      t.references :property, null: false, foreign_key: true
      t.string :title

      t.timestamps
    end
  end
end
