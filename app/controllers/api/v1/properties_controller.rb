module Api::V1
  class PropertiesController < ApplicationController
    def index
      @properties = Property.all
      properties_to_return = @properties.map { |p| p.as_json.merge(display_name: p.display_name) }
      render json: properties_to_return
    end
  end
end
