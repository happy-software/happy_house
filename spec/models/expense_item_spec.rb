# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpenseItem, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:expense_item)).to be_persisted
  end

  describe "validations" do
    it "requires a name" do
      expect(FactoryBot.build(:expense_item, name: nil).valid?).to eq(false)
    end

    it "requires a cost" do
      expect(FactoryBot.build(:expense_item, cost: nil).valid?).to eq(false)
    end

    it "requires an expense_date" do
      expect(FactoryBot.build(:expense_item, expense_date: nil).valid?).to eq(false)
    end
  end

  describe ".for_year" do
    let(:property) { FactoryBot.create(:property) }
    let!(:item_2023) { FactoryBot.create(:expense_item, property: property, expense_date: Date.new(2023, 5, 1)) }
    let!(:item_2024) { FactoryBot.create(:expense_item, property: property, expense_date: Date.new(2024, 5, 1)) }

    it "returns only items from the given year" do
      expect(ExpenseItem.for_year(2023)).to match_array([item_2023])
    end
  end

  describe "attachments" do
    it "accepts multiple attachments" do
      item = FactoryBot.create(:expense_item)
      item.attachments.attach(uploaded_test_file)
      item.attachments.attach(uploaded_test_file)

      expect(item.attachments.count).to eq(2)
    end
  end
end
