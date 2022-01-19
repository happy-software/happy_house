# frozen_string_literal: true

class CreateEvents < ActiveRecord::Migration[6.1]
  def change
    create_table :events do |t|
      t.references :property, null: false, foreign_key: true
      t.datetime :starts_at
      t.datetime :ends_at

      t.timestamps
    end
  end
end
