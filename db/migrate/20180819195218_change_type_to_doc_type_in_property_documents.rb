class ChangeTypeToDocTypeInPropertyDocuments < ActiveRecord::Migration[5.2]
  def change
    rename_column :property_documents, :type, :document_type
  end
end
