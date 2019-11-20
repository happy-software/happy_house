class HoaExpensesController < ApplicationController
  before_action :correct_user

  def index
    @property = Property.find(params[:id])
  end

  def create
    @property = Property.find(create_hoa_expenses_params[:id])
    hoa_payments = @property.property_interface.build_yearly_hoa_payments(create_hoa_expenses_params)
    if hoa_payments.present?
      flash[:success] = "Created 12 home owner's association expense items for #{create_hoa_expenses_params[:year]}"
      redirect_to property_path
    else
      flash[:danger] = "Could not create 12 home owner's association items for #{create_hoa_expenses_params[:year]}"
      redirect_to property_path
    end
  end

  private

  def create_hoa_expenses_params
    @create_hoa_expenses_params ||= params.permit(:id, :year, :monthly_payment)
  end

  def correct_user
    redirect_to root_url unless Property.find(params[:id]).user == current_user
  end
end