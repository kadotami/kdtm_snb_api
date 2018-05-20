class CreateTodos < ActiveRecord::Migration[5.2]
  def change
    create_table :todos do |t|
      t.integer :user_id, :null => false
      t.string :title, :null => false
      t.datetime :limit, :null => false
      t.timestamps
    end
  end
end
