class CreatePlantypestrategyfunds < ActiveRecord::Migration
  def change
    create_table :plantypestrategyfunds, {:primary_key => :plantypestrategyfund_id} do |t|
      t.integer :plantypestrategyfund_id
      t.integer :plantypestrategy_id
      t.integer :plantypefund_id
      t.integer :deposit_plantype_fund_id
      t.integer :market_id

      t.timestamps
    end
  end
end
