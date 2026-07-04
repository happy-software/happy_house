# frozen_string_literal: true

FactoryBot.define do
  factory :insurance_document do
    property
    title { "Insurance Policy" }
    document do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec", "fixtures", "insurance_documents", "upload_test_file.txt"), "text/plain"
      )
    end
  end
end
