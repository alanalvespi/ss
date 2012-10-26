class Plantype < ActiveRecord::Base
  attr_accessible :company_id, :deposit_fund_id, :last_mod, :plantype_currency, :plantype_id, :plantype_name, :reason, :state, :product_id

end
