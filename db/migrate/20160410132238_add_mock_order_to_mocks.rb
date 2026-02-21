class AddMockOrderToMocks < ActiveRecord::Migration[4.2]
  def up
    add_column :mocks, :mock_order, :integer

    Duckrails::Mock.reset_column_information
    Duckrails::Mock.all.each_with_index do |mock, index|
      mock.update_attributes!(mock_order: index)
    end

    change_column :mocks, :mock_order, :integer, null: false, index: { unique: true }
  end

  def down
    remove_column :mocks, :mock_order
  end
end
