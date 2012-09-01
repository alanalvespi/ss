class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets , {:primary_key => :market_id}do |t|
      t.integer :market_id
      t.string :market_name
      t.string :query_name
      t.string :query_section
      t.string :market_msci_name
      t.integer :msci_index_code
      t.integer :market_in
      t.date :market_current_date
      t.decimal :market_current_price
      t.decimal :market_dailychange
      t.date :market_reference_date
      t.decimal :market_reference_price
      t.decimal :market_change_from_ref
      t.decimal :market_change_from_switch
      t.integer :market_override
      t.string :market_switch
      t.date :market_last_switch_date
      t.decimal :market_last_switch_price
      t.date :market_current_process_date
      t.integer :state
      t.string :reason
      t.string :market_currency

      t.timestamps
    end
  end
end
