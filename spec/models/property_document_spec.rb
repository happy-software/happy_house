# frozen_string_literal: true

require "rails_helper"

# PropertyDocument is dead code ("TODO: Can delete this model" in the model
# itself) — slated for removal during the framework upgrades. This smoke test
# only ensures it keeps loading until then.
RSpec.describe PropertyDocument, type: :model do
  it "instantiates" do
    expect(PropertyDocument.new).to be_a(PropertyDocument)
  end
end
