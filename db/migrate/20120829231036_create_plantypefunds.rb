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

      t.timestamps
    end
  end
end
