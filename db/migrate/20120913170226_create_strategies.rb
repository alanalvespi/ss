class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies do |t|
      t.integer :strategy_id
      t.string :strategy_name
      t.float :strategy_initial_switch_percentage
      t.float :strategy_filter
      t.float :strategy_trigger_in
      t.float :strategy_trigger_out

      t.timestamps
    end
  end
end
