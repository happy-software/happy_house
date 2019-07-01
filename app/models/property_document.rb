class PropertyDocument < ApplicationRecord
  belongs_to :property
#  belongs_to :property_document_type
  has_one :lease
  has_one_attached :document

#  accepts_nested_attributes_for :property_document_type, allow_destroy: false

  # @param [Integer] property_id
  # @param [ActionDispatch::Http::UploadedFile] uploaded_file
  #
  # @return [PropertyDocument]
  def self.from_upload(property_id, uploaded_file)
    name = uploaded_file.original_filename

    new.tap do |document|
      document.property_id = property_id
      document.name = name
    end
  end
end
