# frozen_string_literal: true

class AddPropertyToExpenseItem < ActiveRecord::Migration[5.2]
  def change
    add_reference :expense_items, :property, foreign_key: true
  end
end
