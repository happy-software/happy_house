# frozen_string_literal: true

require "rails_helper"

# Dead code along with PropertyDocument — see that spec's note.
RSpec.describe PropertyDocumentType, type: :model do
  it "instantiates" do
    expect(PropertyDocumentType.new).to be_a(PropertyDocumentType)
  end
end
