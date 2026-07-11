# frozen_string_literal: true

require "rails_helper"

RSpec.describe ExpenseItemHelpers::OneOffUploaders do
  let(:property) { FactoryBot.create(:property) }

  describe ".create_yearly_mortgage_payments!" do
    it "creates 12 correctly named and dated expense items" do
      expect { ExpenseItem.create_yearly_mortgage_payments!(property, 2024, 1200.50) }
        .to change(property.expense_items, :count).by(12)

      items = property.expense_items.order(:expense_date)
      expect(items.first.name).to eq("1-2024 Mortgage Payment")
      expect(items.last.name).to eq("12-2024 Mortgage Payment")
      expect(items.map(&:cost).uniq).to eq([1200.50])
      # expense_date is stored as UTC midnight (DateTime.parse), so read it
      # back in UTC — in the app's Eastern zone it displays as the prior day.
      expect(items.map { |i| i.expense_date.utc.to_date })
        .to eq((1..12).map { |m| Date.new(2024, m, 1) })
    end
  end

  describe ".create_yearly_hoa_payments!" do
    it "creates 12 correctly named HOA expense items" do
      expect { ExpenseItem.create_yearly_hoa_payments!(property, 2024, 150.0) }
        .to change(property.expense_items, :count).by(12)

      expect(property.expense_items.pluck(:name)).to include("1-2024 HOA Payment", "12-2024 HOA Payment")
    end
  end

  describe "HappyHouse::Expenses wrappers" do
    it "YearlyMortgage.create_new_mortgage_payments! delegates" do
      expect { HappyHouse::Expenses::YearlyMortgage.create_new_mortgage_payments!(property, 2023, 900.0) }
        .to change(property.expense_items, :count).by(12)
    end

    it "YearlyHoa.create_new_hoa_payments! delegates" do
      expect { HappyHouse::Expenses::YearlyHoa.create_new_hoa_payments!(property, 2023, 85.0) }
        .to change(property.expense_items, :count).by(12)
    end
  end
end
