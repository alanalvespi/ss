class CreatePlantypeStrategies < ActiveRecord::Migration
  def change
    create_table :plantype_strategies do |t|
      t.integer :plantype_strategy
      t.integer :plantype_id
      t.integer :strategy_id
      t.integer :plantypestrategyFund_id
      t.integer :deposit_fund_id

      t.timestamps
    end
  end
end
