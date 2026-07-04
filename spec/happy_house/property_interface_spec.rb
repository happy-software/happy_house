# frozen_string_literal: true

require "rails_helper"

describe "HappyHouse::PropertyInterface" do
  let(:property) { FactoryBot.create(:property) }
  let(:instance) { property.property_interface }

  context "#transfer_ownership" do
    let(:property) { FactoryBot.create(:property, user: original_user) }
    let(:original_user) { FactoryBot.create(:user) }
    let(:new_user)      { FactoryBot.create(:user) }

    it "succeeds" do
      expect(instance.user).to eq(original_user)
      instance.transfer_ownership(new_user)
      expect(instance.user).to eq(new_user)
    end
  end

  context "#yearly_expense_summary" do
    it "sums costs per year as formatted strings" do
      FactoryBot.create(:expense_item, property: property, cost: 10.5,  expense_date: Date.new(2023, 2, 1))
      FactoryBot.create(:expense_item, property: property, cost: 20.25, expense_date: Date.new(2023, 9, 1))
      FactoryBot.create(:expense_item, property: property, cost: 5,     expense_date: Date.new(2024, 1, 1))

      expect(instance.yearly_expense_summary).to eq({ "2023" => "30.75", "2024" => "5.00" })
    end
  end

  context "#monthly_expense_summary" do
    it "sums costs per month for the given year only" do
      FactoryBot.create(:expense_item, property: property, cost: 100, expense_date: Date.new(2024, 6, 5))
      FactoryBot.create(:expense_item, property: property, cost: 50,  expense_date: Date.new(2024, 6, 20))
      FactoryBot.create(:expense_item, property: property, cost: 25,  expense_date: Date.new(2024, 7, 1))
      FactoryBot.create(:expense_item, property: property, cost: 999, expense_date: Date.new(2023, 6, 1))

      summary = instance.monthly_expense_summary("2024")

      expect(summary["Jun 2024"]).to eq("150.00")
      expect(summary["Jul 2024"]).to eq("25.00")
      expect(summary.keys).to_not include("Jun 2023")
    end
  end

  context "#build_expense_report" do
    it "returns total cost and date-ordered expense hashes" do
      late  = FactoryBot.create(:expense_item, property: property, name: "Late",  cost: 20.0,
                                               expense_date: Date.new(2024, 9, 1))
      early = FactoryBot.create(:expense_item, property: property, name: "Early", cost: 10.0,
                                               expense_date: Date.new(2024, 1, 1))
      FactoryBot.create(:expense_item, property: property, cost: 5.0, expense_date: Date.new(2023, 1, 1))

      report = instance.build_expense_report(year: 2024)

      expect(report[:total_cost]).to eq(30.0)
      expect(report[:expenses].map { |e| e[:name] }).to eq(%w[Early Late])
      expect(report[:expenses].first.keys).to match_array(%i[id name cost date])
      expect(report[:expenses].first[:id]).to eq(early.id)
      expect(report[:expenses].last[:id]).to eq(late.id)
    end
  end

  context "#build_yearly_hoa_payments" do
    it "raises without a year" do
      expect { instance.build_yearly_hoa_payments(monthly_payment: "100.0") }
        .to raise_error(ArgumentError, "Missing year")
    end

    it "raises without a monthly_payment" do
      expect { instance.build_yearly_hoa_payments(year: "2024") }
        .to raise_error(ArgumentError, "Missing monthly_payment")
    end

    it "creates 12 HOA expense items" do
      expect { instance.build_yearly_hoa_payments(year: "2024", monthly_payment: "150.0") }
        .to change(property.expense_items, :count).by(12)
    end
  end

  context "#build_yearly_mortgage_payment" do
    it "raises without a year" do
      expect { instance.build_yearly_mortgage_payment(monthly_payment: "100.0") }
        .to raise_error(ArgumentError, "Missing year")
    end

    it "raises without a monthly_payment" do
      expect { instance.build_yearly_mortgage_payment(year: "2024") }
        .to raise_error(ArgumentError, "Missing monthly_payment")
    end

    it "creates 12 mortgage expense items" do
      expect { instance.build_yearly_mortgage_payment(year: "2024", monthly_payment: "1000.0") }
        .to change(property.expense_items, :count).by(12)
    end
  end
end
