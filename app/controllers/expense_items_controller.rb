# frozen_string_literal: true

class ExpenseItemsController < ApplicationController
  before_action :correct_user

  def index
    @expense_items ||= property.expense_items
    @yearly_expense_summary = interface.yearly_expense_summary
    @available_years        = property.expense_years
    @property_name          = property.display_name
  end

  def new
    @expense_item = property.expense_items.new
  end

  def create
    @expense_item = property.expense_items.new(expense_item_params)

    if @expense_item.save
      flash[:info] = "Expense (#{@expense_item.name}) saved!"
      redirect_to user_property_expense_items_url
    else
      render "new"
    end
  end

  def show
    @expense_item = property.expense_items.find(params[:id])
    fresh_when(@expense_item)
  end

  def edit
    @expense_item = property.expense_items.find(params[:id])
  end

  def update
    @expense_item = property.expense_items.find(params[:id])

    if @expense_item&.update(expense_item_params)
      flash[:success] = "Updated Expense Item: #{@expense_item.name}"
      redirect_to user_property_expense_items_url(property_id: @expense_item.property.id)
    else
      render "edit"
    end
  end

  def report
    @year           = params[:expense_year]
    @expense_report = interface.build_expense_report(year: @year)
    @year_summary   = interface.monthly_expense_summary(@year)
  end

  private

  def property
    @property ||= Property.find(params[:property_id])
  end

  def interface
    @interface ||= property.property_interface
  end

  def expense_item_params
    params.require(:expense_item).permit(:name, :cost, :expense_date, :property_id, attachments: [])
  end

  def correct_user
    redirect_to root_url unless Property.find(params[:property_id]).user == current_user
  end
end
