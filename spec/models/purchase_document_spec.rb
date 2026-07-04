# frozen_string_literal: true

require "rails_helper"

RSpec.describe PurchaseDocument, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:purchase_document)).to be_persisted
  end

  it "requires a title" do
    expect(FactoryBot.build(:purchase_document, title: nil).valid?).to eq(false)
  end

  it "requires an attached document" do
    expect(FactoryBot.build(:purchase_document, document: nil).valid?).to eq(false)
  end

  it "requires a property" do
    expect(FactoryBot.build(:purchase_document, property: nil).valid?).to eq(false)
  end
end
