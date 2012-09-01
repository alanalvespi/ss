class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies, {:primary_key => :company_id} do |t|
      t.integer :company_id
      t.string :company_name
      t.date :company_last_update

      t.timestamps
    end
  end
end
