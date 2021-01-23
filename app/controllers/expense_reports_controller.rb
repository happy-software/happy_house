class ExpenseReportsController < ApplicationController

  before_action :correct_user,   only: [:index, :create]

  def index
    @property        = Property.find(params[:id])
    @available_years = @property.property_interface.expense_years
    @property_name   = @property.display_name
    @yearly_expense_summary = @property.property_interface.yearly_expense_summary
  end

  def create
    @property = Property.find(params[:id])
    @year     = params[:expense_year]
    @expense_report = @property.property_interface.build_expense_report(year: @year)
    @year_summary   = @property.property_interface.monthly_expense_summary(@year)
  end

  private

  def correct_user
    redirect_to root_url unless Property.find(params[:id]).user == current_user
  end
end
