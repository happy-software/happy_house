class HoaExpensesController < ApplicationController
  before_action :correct_user

  def index

  end

  def create

  end

  private

  def create_hoa_expenses_params
    @create_mortgage_params ||= params.permit(:id, :year, :monthly_payment)
  end

  def correct_user
    redirect_to root_url unless Property.find(params[:id]).user == current_user
  end
end