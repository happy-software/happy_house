# frozen_string_literal: true

require "happy_house/taxes/expense_reports/builder"
require "happy_house/leases/generator"
require "happy_house/expenses/yearly_mortgage"

module HappyHouse
  class PropertyInterface
    attr_reader :property

    def initialize(property)
      @property = property
    end

    def transfer_ownership(new_owner)
      property.user = new_owner
      property.save!
    end

    def user
      property.user
    end

    def build_expense_report(year: Date.current.year)
      HappyHouse::Taxes::ExpenseReports::Builder.new(property).build_for_year(year)
    end

    def build_yearly_hoa_payments(params)
      raise ArgumentError, "Missing year"            unless year = params[:year]
      raise ArgumentError, "Missing monthly_payment" unless monthly_amount = params[:monthly_payment]

      HappyHouse::Expenses::YearlyHoa.create_new_hoa_payments!(property, year, monthly_amount)
    end

    def build_yearly_mortgage_payment(params)
      raise ArgumentError, "Missing year"            unless year = params[:year]
      raise ArgumentError, "Missing monthly_payment" unless monthly_amount = params[:monthly_payment]

      HappyHouse::Expenses::YearlyMortgage.create_new_mortgage_payments!(property, year, monthly_amount)
    end

    def yearly_expense_summary
      s = property.expense_items.group_by_year(:expense_date, format: "%Y").sum(:cost)
      s.update(s) { |_, v| "%.2f" % v }
    end

    def monthly_expense_summary(year)
      s = property.expense_items.where("extract(year from expense_date) = ?", year).group_by_month(:expense_date,
                                                                                                   format: "%b %Y").sum(:cost)
      s.update(s) { |_, v| "%.2f" % v }
    end

    def renew_lease!(lease = property.leases.newest)
      tenants           = lease.tenants
      new_starting_date = lease.end_date
      new_ending_date   = new_starting_date + 1.year
      rent_amount       = lease.amount.to_f

      @lease_details = {
        street_address: @property.address["street_address"],
        city: @property.address["city"],
        state: @property.address["state"],
        zip_code: @property.address["zip_code"],
        tenants: tenants,
        starting_date: new_starting_date&.strftime("%B %d, %Y %I:%M %p"),
        ending_date: new_ending_date&.strftime("%B %d, %Y %I:%M %p"),
        rent_amount: rent_amount,
        lease_creation_date: Date.current.to_s,
        landlord_name: @property.user.name,
        landlord_email: @property.user.email
      }

      lease_pdf = lease_generator.new(@lease_details).generate!
      Lease.build_lease!(property, @lease_details, lease_pdf)
    end

    def lease_generator
      HappyHouse::Leases::Generator
    end
  end
end
