class Plantypefund < ActiveRecord::Base
  attr_accessible :company_id, :fund_currency, :fund_fkey, :fund_id, :fund_identifier, :fund_name, :fund_type, :market_id
end
