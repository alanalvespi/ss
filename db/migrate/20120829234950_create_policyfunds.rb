class CreatePolicyfunds < ActiveRecord::Migration
  def change
    create_table :policyfunds, {:primary_key => :policyfund_id} do |t|
      t.integer :policyfund_id
      t.integer :policy_id
      t.integer :fund_id
      t.decimal :policyfund_value
      t.date :last_mod
      t.integer :state
      t.string :reason

      t.timestamps
    end
  end
end
