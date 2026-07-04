# frozen_string_literal: true

require "rails_helper"

RSpec.describe Property, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.create(:property)).to be_persisted
  end

  describe "property_type validation" do
    Property::PROPERTY_TYPES.each do |type|
      it "allows #{type}" do
        property = FactoryBot.build(:property, property_type: type.to_s.titleize)
        expect(property.valid?).to eq(true)
      end
    end

    it "rejects unknown types" do
      property = FactoryBot.build(:property, property_type: "Castle")
      expect(property.valid?).to eq(false)
    end

    it "rejects a missing type" do
      property = FactoryBot.build(:property, property_type: nil)
      expect(property.valid?).to eq(false)
    end
  end

  describe "#display_name" do
    it "returns the nickname when present" do
      property = FactoryBot.build(:property, nickname: "The Money Pit")
      expect(property.display_name).to eq("The Money Pit")
    end

    it "falls back to the street address when nickname is nil" do
      property = FactoryBot.build(:property, nickname: nil)
      expect(property.display_name).to eq("123 Happy St.")
    end

    it "falls back to the street address when nickname is blank" do
      property = FactoryBot.build(:property, nickname: "")
      expect(property.display_name).to eq("123 Happy St.")
    end
  end

  describe "property type scopes" do
    let!(:townhome)    { FactoryBot.create(:property, property_type: "Townhome") }
    let!(:sfh)         { FactoryBot.create(:property, property_type: "Single Family Home") }
    let!(:apartment)   { FactoryBot.create(:property, property_type: "Apartment") }
    let!(:condo)       { FactoryBot.create(:property, property_type: "Condo") }
    let!(:commercial)  { FactoryBot.create(:property, property_type: "Commercial") }

    it "filters each type" do
      expect(Property.townhomes).to match_array([townhome])
      expect(Property.single_family_homes).to match_array([sfh])
      expect(Property.apartments).to match_array([apartment])
      expect(Property.condos).to match_array([condo])
      expect(Property.commercials).to match_array([commercial])
    end
  end

  describe "#expense_years" do
    let(:property) { FactoryBot.create(:property) }

    it "returns unique years, newest first" do
      [2022, 2023, 2023, 2024].each do |year|
        FactoryBot.create(:expense_item, property: property, expense_date: Date.new(year, 6, 1))
      end

      expect(property.expense_years).to eq([2024, 2023, 2022])
    end
  end

  describe "#property_interface" do
    it "returns a memoized HappyHouse::PropertyInterface" do
      property = FactoryBot.create(:property)

      interface = property.property_interface
      expect(interface).to be_a(HappyHouse::PropertyInterface)
      expect(property.property_interface).to equal(interface)
    end
  end
end
