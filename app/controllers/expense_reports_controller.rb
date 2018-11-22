class ExpenseReportsController < ApplicationController
  def index
    @property = Property.find(params[:id])
  end

  def create
    @property = Property.find(params[:id])
    @expense_report = @property.property_interface.build_expense_report(year: params[:expense_year])

    # TODO: build create view
  end
end
