# frozen_string_literal: true

class RemoveDocumentTypeFromPropertyDocument < ActiveRecord::Migration[5.2]
  def change
    remove_column :property_documents, :document_type
  end
end
