class ExpenseItemsController < ApplicationController
  def index
    @expense_items ||= property.expense_items
  end

  def new
    @expense_item = property.expense_items.new
  end

  def create
    @expense_item = property.expense_items.new(expense_item_params)

    if @expense_item.save
      flash[:info] = "Expense (#{@expense_item.name}) saved!"
      redirect_to property_expense_items_url
    else
      render 'new'
    end
  end

  private

  def property
    @property ||= Property.find(params[:property_id])
  end

  def expense_item_params
    params.require(:expense_item).permit(:name, :cost, :expense_date, :property_id)
  end
end
