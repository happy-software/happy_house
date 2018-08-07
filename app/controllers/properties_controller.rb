class PropertiesController < ApplicationController
  def new
    @property = current_user.properties.new
  end

  def create
    p = current_user.properties.new(address: properties_params[:address],
                                    nickname: properties_params[:nickname],
                                    property_type: properties_params[:property_type].parameterize.underscore)
    if p.save
      flash[:success] = 'New Happy Home added!'
      redirect_to current_user
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
      flash[:success] = 'Updated ' + @property.address['street_address']
      redirect_to current_user
    else
      render 'edit'
    end
  end

  private

    def properties_params
      params.require(:property).permit(:nickname, :property_type, address: [:street_address, :city, :state, :zip_code])
    end
end
