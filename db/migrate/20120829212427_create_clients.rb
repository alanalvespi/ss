class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients, {:primary_key => :client_id} do |t|
      t.integer :client_id
      t.string :client_name
      t.string :full_address
      t.string :client_company_address
      t.integer :client_company_address_change
      t.date :last_mod
      t.integer :state
      t.string :reason

      t.timestamps
    end
  end
end
