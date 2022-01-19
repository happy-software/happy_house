# frozen_string_literal: true

class CreateExpenseItems < ActiveRecord::Migration[5.2]
  def change
    create_table :expense_items do |t|
      t.string :name
      t.float :cost
      t.datetime :expense_date

      t.timestamps
    end
  end
end
