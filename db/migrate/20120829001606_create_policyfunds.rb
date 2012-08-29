class CreatePolicyfunds < ActiveRecord::Migration
  def change
    create_table :policyfunds do |t|
      t.integer :policyfund_id
      t.integer :policy_id
      t.integer :fund_id
      t.decimal :policyfund_value
      t.integer :state
      t.string :reason

      t.timestamps
    end
  end
end
