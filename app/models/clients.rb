class Clients < ActiveRecord::Base
  attr_accessible :client_company_address, :client_company_address_change, :client_id, :client_name, :full_address
end
