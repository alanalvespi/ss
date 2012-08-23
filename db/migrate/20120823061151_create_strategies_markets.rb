class CreateStrategiesMarkets < ActiveRecord::Migration
  def change
    create_table :strategies_markets do |t|
      t.integer :strategy_market_id
      t.integer :strategy_id
      t.integer :market_id

      t.timestamps
    end
  end
end
