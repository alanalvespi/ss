class Policyfunds < ActiveRecord::Base
  attr_accessible :fund_id, :last_mod, :policy_id, :policyfund_id, :policyfund_value, :reason, :state
end
