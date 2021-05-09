require_relative '../services/price_history_service'

class PropertiesController < ApplicationController
  before_action :correct_user, only: [:show, :upload_files, :update, :edit]
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
    @property           = current_user.properties.find(params[:id])
    @price_history_data = PriceHistoryService.new(@property.zpid).get_history
  end
  
  def upload_files
    if current_property.update_attributes(properties_params)
      flash[:info] = 'Successfully uploaded your documents!'
    else
      flash[:danger] = 'Error: Could not upload your documents!'
    end

    redirect_to property_path(current_property)
  end

  private

  def current_property
    Property.find(params[:id])
  end

  def properties_params
    params.require(:property).permit(:nickname, :id,
                                     :property_type,
                                     address: [:street_address, :city, :state, :zip_code],
                                     documents: [])
  end

  def correct_user
    redirect_to root_url unless Property.find(params[:id]).user == current_user
  end
end
