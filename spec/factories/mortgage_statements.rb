# frozen_string_literal: true

FactoryBot.define do
  factory :mortgage_statement do
    property
    title { "Mortgage Statement" }
    document do
      Rack::Test::UploadedFile.new(
        Rails.root.join("spec", "fixtures", "insurance_documents", "upload_test_file.txt"), "text/plain"
      )
    end
  end
end
