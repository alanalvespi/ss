class Plantypefund < ActiveRecord::Base
  attr_accessible :company_id, :fund_currency, :fund_fkey, :fund_id, :fund_identifier, :fund_isin, :fund_name, :fund_type, :market_id, :plantype_id, :reason, :state
end
