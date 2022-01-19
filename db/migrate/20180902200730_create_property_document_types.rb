# frozen_string_literal: true

class CreatePropertyDocumentTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :property_document_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
