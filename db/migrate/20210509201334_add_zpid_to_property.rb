# frozen_string_literal: true

class AddZpidToProperty < ActiveRecord::Migration[6.0]
  def change
    add_column :properties, :zpid, :string
  end
end
