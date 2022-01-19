# frozen_string_literal: true

class AddUsersReferenceToProperty < ActiveRecord::Migration[5.2]
  def change
    add_reference :properties, :user, foreign_key: true
  end
end
