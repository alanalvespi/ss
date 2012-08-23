class CreatePlantypefunds < ActiveRecord::Migration
  def change
    create_table :plantypefunds do |t|
      t.integer :fund_id
      t.string :fund_name
      t.string :fund_identifier
      t.integer :market_id
      t.string :fund_currency
      t.string :fund_fkey
      t.string :fund_type
      t.integer :company_id
      t.integer :plantype_id
      t.string :fund_isin
      t.datetime :last_mod
      t.integer :state
      t.string :reason

      t.timestamps
    end
  end
end
