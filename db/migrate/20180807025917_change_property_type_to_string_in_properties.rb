# frozen_string_literal: true

class ChangePropertyTypeToStringInProperties < ActiveRecord::Migration[5.2]
  def change
    change_column :properties, :property_type, :string
    add_index :properties, :property_type
  end
end
