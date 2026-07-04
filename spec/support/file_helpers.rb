# frozen_string_literal: true

module FileHelpers
  FIXTURE_FILE_PATH = Rails.root.join("spec", "fixtures", "insurance_documents", "upload_test_file.txt")

  # For request specs / params
  def uploaded_test_file
    Rack::Test::UploadedFile.new(FIXTURE_FILE_PATH, "text/plain")
  end
end

RSpec.configure do |config|
  config.include FileHelpers
end
