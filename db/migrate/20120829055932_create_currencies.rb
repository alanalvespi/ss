class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies , {:primary_key => :currency_id}do |t|
      t.integer :currency_id
      t.string :currency_name

      t.timestamps
    end
  end
end
