class ExpenseReportsController < ApplicationController
  before_action :correct_user,   only: [:index, :create]

  def index
    @property = Property.find(params[:id])
  end

  def create
    @property = Property.find(params[:id])
    @year     = params[:expense_year]
    @expense_report = @property.property_interface.build_expense_report(year: @year)
  end

  private

  def correct_user
    redirect_to root_url unless Property.find(params[:id]).user == current_user
  end
end
