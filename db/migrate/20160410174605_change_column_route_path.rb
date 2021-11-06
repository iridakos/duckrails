class ChangeColumnRoutePath < ActiveRecord::Migration[4.2]
  def change
    remove_index :mocks, :request_method_and_route_path
  end
end
