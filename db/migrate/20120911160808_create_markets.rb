class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets, {:primary_key => :market_id} do |t|
      t.integer :market_id
      t.string :market_friendly_name
      t.string :market_classification
      t.string :query_name
      t.string :query_section
      t.string :market_msci_name
      t.integer :msci_index_code
      t.integer :market_in
      t.date :market_current_date
      t.float :market_current_price
      t.float :market_dailychange
      t.date :market_reference_date
      t.float :market_reference_price
      t.float :market_change_from_ref
      t.float :market_change_from_switch
      t.integer :market_override
      t.string :market_switch
      t.date :market_last_switch_date
      t.float :market_last_switch_price
      t.date :market_current_process_date
      t.timestamp :last_mod
      t.integer :state
      t.string :reason
      t.string :market_currency

      t.timestamps
    end
  end
end
