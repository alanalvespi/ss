class Policies < ActiveRecord::Base
  attr_accessible :client_id, :last_mod, :plantype_id, :policy_amount_on_deposit, :policy_currency, :policy_id, :policy_missing, :policy_no_markets_invested, :policy_number, :policy_single_premium, :policy_start, :policy_total_invested, :policy_value, :reason, :state, :strategy_id
end
