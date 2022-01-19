# frozen_string_literal: true

class ChangePropertyTypeToIntegerInProperties < ActiveRecord::Migration[5.2]
  def change
    remove_column :properties, :type, :string
    add_column :properties, :property_type, :integer
  end
end
