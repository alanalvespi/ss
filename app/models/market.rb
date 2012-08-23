class Market < ActiveRecord::Base
  attr_accessible :market_change_from_ref, :market_change_from_switch, :market_current_date, :market_current_price, :market_current_process_date, :market_dailychange, :market_id, :market_in, :market_last_switch_date, :market_last_switch_price, :market_msci_name, :market_name, :market_override, :market_reference_date, :market_reference_price, :market_switch, :msci_index_code, :query_name, :query_section
end
