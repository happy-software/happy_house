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

  private

    def properties_params
      params.require(:property).permit(:nickname, :property_type, address: [:street_address, :city, :state, :zip_code])
    end
end
