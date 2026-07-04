# frozen_string_literal: true

require "rails_helper"

RSpec.describe MortgageStatement, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:mortgage_statement)).to be_persisted
  end

  it "requires a title" do
    expect(FactoryBot.build(:mortgage_statement, title: nil).valid?).to eq(false)
  end

  it "requires an attached document" do
    expect(FactoryBot.build(:mortgage_statement, document: nil).valid?).to eq(false)
  end

  it "requires a property" do
    expect(FactoryBot.build(:mortgage_statement, property: nil).valid?).to eq(false)
  end

  it "stores rich-text notes" do
    statement = FactoryBot.create(:mortgage_statement)
    statement.update!(notes: "<div>Refinanced in <strong>2024</strong></div>")

    expect(statement.reload.notes.to_plain_text).to include("Refinanced in 2024")
  end
end
