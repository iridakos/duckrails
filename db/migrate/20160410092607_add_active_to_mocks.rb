class AddActiveToMocks < ActiveRecord::Migration[4.2]
  def change
    add_column :mocks, :active, :boolean, null: false, default: true
  end
end
