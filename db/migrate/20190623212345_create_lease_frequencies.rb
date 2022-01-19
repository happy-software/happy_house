# frozen_string_literal: true

class CreateLeaseFrequencies < ActiveRecord::Migration[5.2]
  def change
    create_table :lease_frequencies do |t|
      t.string :frequency

      t.timestamps
    end
  end
end
