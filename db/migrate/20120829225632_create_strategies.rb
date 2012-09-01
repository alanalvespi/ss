class CreateStrategies < ActiveRecord::Migration
  def change
    create_table :strategies, {:primary_key => :strategy_id} do |t|
      t.integer :strategy_id
      t.string :strategy_name
      t.integer :strategy_initial_switch_percentage
      t.integer :strategy_filter
      t.decimal :strategy_trigger_in
      t.decimal :strategy_trigger_out

      t.timestamps
    end
  end
end
