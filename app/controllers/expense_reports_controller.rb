class ExpenseReportsController < ApplicationController

  before_action :correct_user,   only: [:index, :create]

  def index
    interface               = @property.property_interface
    @available_years        = interface.expense_years
    @property_name          = @property.display_name
    @yearly_expense_summary = interface.yearly_expense_summary
  end

  def create
    @year     = params[:expense_year]
    interface = @property.property_interface
    @expense_report = interface.build_expense_report(year: @year)
    @year_summary   = interface.monthly_expense_summary(@year)
  end

  private

  def correct_user
    redirect_to root_url unless property.user == current_user
  end

  def property
    @property ||= Property.find(params[:property_id])
  end
end
