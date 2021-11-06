class CreateApplicationStates < ActiveRecord::Migration[4.2]
  def change
    create_table :application_state do |t|
      t.integer :singleton_guard, default: 0
      t.string  :mock_synchronization_token

      t.timestamps null: false
    end

    add_index(:application_state, :singleton_guard, :unique => true)
  end
end
