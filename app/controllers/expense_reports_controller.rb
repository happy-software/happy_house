class ExpenseReportsController < ApplicationController
  def index
    @property = Property.find(params[:id])
  end

  def create
    @property = Property.find(params[:id])
    @year     = params[:expense_year]
    @expense_report = @property.property_interface.build_expense_report(year: @year)
  end
end
