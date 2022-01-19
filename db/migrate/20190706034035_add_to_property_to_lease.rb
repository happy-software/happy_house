# frozen_string_literal: true

class AddToPropertyToLease < ActiveRecord::Migration[5.2]
  def change
    add_reference :leases, :property, foreign_key: true
  end
end
