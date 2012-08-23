class Strategies < ActiveRecord::Base
  attr_accessible :strategy_filter, :strategy_id, :strategy_initial_switch_percentage, :strategy_name, :strategy_trigger_in, :strategy_trigger_out
end
