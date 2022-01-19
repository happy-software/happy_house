# frozen_string_literal: true

class CreateUtilityAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :utility_accounts do |t|
      t.string :name
      t.jsonb :details
      t.references :property, foreign_key: true

      t.timestamps
    end
  end
end
