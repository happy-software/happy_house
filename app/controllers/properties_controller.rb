class PropertiesController < ApplicationController
  def new
    @property = current_user.properties.new
  end

  def create
    debugger
  end

  private

    def properties_params
      params.require(:property).permit(:nickname, :property_type, address: [:street_address, :city, :state, :zip_code])
    end
end
