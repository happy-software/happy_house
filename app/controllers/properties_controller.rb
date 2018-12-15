class PropertiesController < ApplicationController
  before_action :correct_user, only: [:show]
  def new
    @property = current_user.properties.new
  end

  def create
    @property = current_user.properties.new(properties_params)
    if @property.save
      flash[:success] = 'New Happy Home added!'
      redirect_to root_url
    else
      render 'new'
    end
  end

  def edit
    @property = Property.find(params[:id])
  end

  def update
    @property = Property.find_by(id: params[:id])
    if @property.update_attributes(properties_params)
      flash[:success] = 'Updated: ' + @property.display_name
      redirect_to current_user
    else
      render 'edit'
    end
  end

  def index
    @user = current_user
    @properties = @user.properties
  end

  def show
    @property = current_user.properties.find(params[:id])
  end

  def create_expense_report
    @property = Property.find(params[:id])
  end

  private

    def properties_params
      params.require(:property).permit(:nickname,
                                       :property_type,
                                       property_documents_attributes: [:property_document_type_id, :name, :document],
                                       address: [:street_address, :city, :state, :zip_code])
    end

  def correct_user
    redirect_to root_url unless Property.find(params[:id]).user == current_user
  end
end
