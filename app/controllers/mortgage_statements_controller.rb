class MortgageStatementsController < ApplicationController
  before_action :logged_in?
  before_action :correct_user
  before_action :set_property
  
  def index
    @mortgage_statements = @property.mortgage_statements.order(created_at: :desc)
  end

  def new
    @mortgage_statement = @property.mortgage_statements.build
  end
  
  def create
    @mortgage_statement = @property.mortgage_statements.new(mortgage_statement_params)
    
    if @mortgage_statement.save
      redirect_to(user_property_mortgage_statements_path([@current_user, @property]), notice: "Successfully Uploaded")
    else
      render :new
    end
  end

  def show
    @mortgage_statement = @property.mortgage_statements.find(params[:id])
  end

  def edit
    @mortgage_statement = @property.mortgage_statements.find(params[:id])
  end

  def update
    @mortgage_statement = @property.mortgage_statements.find(params[:id])
    if @mortgage_statement.update(mortgage_statement_params)
      redirect_to [@current_user, @property, @mortgage_statement], notice: "Document details updated successfully."
    else
      render :edit
    end
  end
  
  private
  
  def correct_user
    redirect_to root_url unless Property.find(params[:property_id]).user == current_user
  end

  def set_property
    @property = current_user.properties.find(params[:property_id])
  end

  def mortgage_statement_params
    params.require(:mortgage_statement).permit(:title, :document, :notes)
  end
end