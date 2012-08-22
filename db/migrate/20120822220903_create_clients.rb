class CreateClients < ActiveRecord::Migration
  def change
    create_table :clients do |t|
      t.integer :client_id
      t.string :client_name
      t.string :full_address
      t.string :client_company_address
      t.integer :client_company_address_change

      t.timestamps
    end
  end
end
