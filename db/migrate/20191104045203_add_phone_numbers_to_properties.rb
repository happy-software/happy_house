class AddPhoneNumbersToProperties < ActiveRecord::Migration[5.2]
  def change
    add_column :properties, :phone_numbers, :string, null: false, array: true, default: []
  end
end
