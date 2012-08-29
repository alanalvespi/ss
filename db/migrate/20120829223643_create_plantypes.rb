class CreatePlantypes < ActiveRecord::Migration
  def change
    create_table :plantypes do |t|
      t.integer :plantype_id
      t.string :plantype_name
      t.integer :company_id
      t.string :plantype_currency
      t.integer :deposit_fund_id
      t.date :last_mod
      t.integer :state
      t.string :reason

      t.timestamps
    end
  end
end
