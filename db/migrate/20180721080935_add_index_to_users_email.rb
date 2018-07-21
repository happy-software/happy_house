class AddIndexToUsersEmail < ActiveRecord::Migration[5.2]
  def change
    def change
      add_index :users, :email, unique: true
    end
  end
end
