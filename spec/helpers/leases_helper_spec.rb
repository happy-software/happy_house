# frozen_string_literal: true

require "rails_helper"

# LeasesHelper defines no methods; this spec only pins that it loads.
RSpec.describe LeasesHelper, type: :helper do
  it "is defined" do
    expect(described_class).to be_a(Module)
  end
end
