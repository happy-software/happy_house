# frozen_string_literal: true

class AddPropertyDocumentTypeToPropertyDocument < ActiveRecord::Migration[5.2]
  def change
    add_reference :property_documents, :property_document_type, index: true
  end
end
