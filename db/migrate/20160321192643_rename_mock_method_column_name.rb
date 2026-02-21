class RenameMockMethodColumnName < ActiveRecord::Migration[4.2]
  def change
    rename_column :mocks, :method, :request_method
  end
end
