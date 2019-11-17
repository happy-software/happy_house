class MortgageExpensesController < ApplicationController
  before_action :correct_user

  def index
    @property = Property.find(params[:id])
  end

  def create
    @property = Property.find(params[:id])
    @property.property_interface.build_yearly_mortgage_payment(params[:year])
  end

  private

  def correct_user
    redirect_to root_url unless Property.find(params[:id]).user == current_user
  end
end
