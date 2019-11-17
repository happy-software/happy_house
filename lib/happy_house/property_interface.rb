require 'happy_house/taxes/expense_reports/builder'
require 'happy_house/leases/generator'

module HappyHouse
  class PropertyInterface
    attr_reader :property

    def initialize(property)
      @property = property
    end

    def build_expense_report(year: Date.current.year)
      HappyHouse::Taxes::ExpenseReports::Builder.new(property).build_for_year(year)
    end

    def build_yearly_mortgage_payment(year)
      HappyHouse::Expenses::YearlyMortgage.build
    end

    def expense_years
      property.expense_items.map { |e| e.expense_date.year }.uniq.sort.reverse
    end

    def renew_lease!(lease=property.leases.newest)
      tenants           = lease.tenants
      new_starting_date = lease.end_date
      new_ending_date   = new_starting_date + 1.year
      rent_amount       = lease.amount.to_f

      @lease_details = {
        street_address:    @property.address['street_address'],
        city:              @property.address['city'],
        state:             @property.address['state'],
        zip_code:          @property.address['zip_code'],
        tenants:           tenants,
        starting_date:     new_starting_date&.strftime("%B %d, %Y %I:%M %p"),
        ending_date:       new_ending_date&.strftime("%B %d, %Y %I:%M %p"),
        rent_amount:       rent_amount,
        lease_creation_date: Date.current.to_s,
        landlord_name:     @property.user.name,
        landlord_email:    @property.user.email,
      }

      lease_pdf = lease_generator.new(@lease_details).generate!
      Lease.build_lease!(property, @lease_details, lease_pdf)
    end

    def lease_generator
      HappyHouse::Leases::Generator
    end
  end
end
