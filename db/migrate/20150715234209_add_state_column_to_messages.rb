class AddStateColumnToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :status, :string
  end
end
