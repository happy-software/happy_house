# frozen_string_literal: true

class CreatePropertyDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :property_documents do |t|
      t.string :type
      t.string :name
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
