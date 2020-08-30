class ExpenseItemsController < ApplicationController
  before_action :correct_user,   only: [:index, :new, :create]

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

  def show
    Rails.logger.debug("Params in show action for Expense Item: #{params}")
    @expense_item = property.expense_items.find(params[:id])
  end

  def edit
    Rails.logger.debug("Params in edit action for Expense Item: #{params}")
    @expense_item = property.expense_items.find(params[:id])
  end

  def update
    @expense_item = property.expense_items.find(params[:id])

    if @expense_item&.update_attributes(expense_item_params)
      flash[:success] = "Updated Expense Item: #{@expense_item.name}"
      redirect_to @expense_item.property
    else
      render 'edit'
    end
  end

  private

  def property
    @property ||= Property.find(params[:property_id])
  end

  def expense_item_params
    params.require(:expense_item).permit(:name, :cost, :expense_date, :property_id, attachments: [])
  end

  def correct_user
    redirect_to root_url unless Property.find(params[:property_id]).user == current_user
  end
end
