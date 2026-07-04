# frozen_string_literal: true

require "rails_helper"

# ExpenseItemsHelper defines no methods; this spec only pins that it loads.
RSpec.describe ExpenseItemsHelper, type: :helper do
  it "is defined" do
    expect(described_class).to be_a(Module)
  end
end
