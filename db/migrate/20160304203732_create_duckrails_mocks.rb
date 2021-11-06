class CreateDuckrailsMocks < ActiveRecord::Migration[4.2]
  def change
    create_table :mocks do |t|
      t.string :name, null: false
      t.text :description
      t.integer :status, null: false
      t.string :content_type, null: false
      t.string :method, null: false
      t.string :route_path, null: false
      t.string :body_type
      t.text :body_content
      t.string :script_type
      t.text :script

      t.timestamps null: false
    end

    add_index :mocks, [:method, :route_path], unique: true
    add_index :mocks, :name, unique: true
  end
end
