# frozen_string_literal: true

class AddNicknameToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :nickname, :string
  end
end
