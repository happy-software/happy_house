class ExpenseReportsController < ApplicationController
  def index
    @property = Property.find(params[:id])
  end
end
