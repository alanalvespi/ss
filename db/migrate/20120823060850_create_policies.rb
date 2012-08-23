class CreatePolicies < ActiveRecord::Migration
  def change
    create_table :policies do |t|
      t.integer :policy_id
      t.string :policy_number
      t.date :policy_start
      t.string :policy_currency
      t.integer :client_id
      t.integer :plantype_id
      t.decimal :policy_amount_on_deposit
      t.integer :strategy_id
      t.integer :policy_no_markets_invested
      t.decimal :policy_value
      t.integer :policy_single_premium
      t.decimal :policy_total_invested
      t.integer :policy_missing

      t.timestamps
    end
  end
end
