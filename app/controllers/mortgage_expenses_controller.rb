class MortgageExpensesController < ApplicationController
  before_action :correct_user

  def index
    @property = Property.find(params[:id])
  end

  def create
    @property = Property.find(create_mortgage_params[:id])
    @property.property_interface.build_yearly_mortgage_payment(create_mortgage_params)
  end

  private

  def create_mortgage_params
    @create_mortgage_params ||= params.permit(:id, :year, :monthly_payment)
  end

  def correct_user
    redirect_to root_url unless Property.find(params[:id]).user == current_user
  end
end
