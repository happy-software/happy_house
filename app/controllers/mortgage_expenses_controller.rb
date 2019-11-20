class MortgageExpensesController < ApplicationController
  before_action :correct_user

  def index
    @property = Property.find(params[:id])
  end

  def create
    @property = Property.find(create_mortgage_params[:id])
    mortgage_payments = @property.property_interface.build_yearly_mortgage_payment(create_mortgage_params)
    if mortgage_payments.present?
      flash[:success] = "Created 12 mortgage expense items for #{create_mortgage_params[:year]}"
      redirect_to property_path
    else
      flash[:danger] = "Could not create 12 mortgage expense items for #{create_mortgage_params[:year]}"
      redirect_to property_path
    end
  end

  private

  def create_mortgage_params
    @create_mortgage_params ||= params.permit(:id, :year, :monthly_payment)
  end

  def correct_user
    redirect_to root_url unless Property.find(params[:id]).user == current_user
  end
end
