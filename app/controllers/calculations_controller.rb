class CalculationsController < ApplicationController

require 'find'

    
  # get calculation/switches
  def switch
    @calculations = {}
    @calculations['Running At:'] = Time.current
    # Temporary Hack...  (only Strategy 1)    
    s = Strategies.find(1)
    
    # Select all Markets upon which to do the Switch calculation
    @markets = Market.where("market_current_date > market_current_process_date")
    noMarkets = 0
    @markets.each do | m |
      noMarkets += 1
      
      # Calculate Override... 
      m.market_change_from_ref = (m.market_current_price / m.market_reference_price) - 1.0
      m.market_override = 0
      if ((m.market_in == 0) and (m.market_daily_change) > (s.strategy_filter * s.strategy_trigger_in))  then   
        m.market_override = 1
      elsif ((m.market_in ==1) and (m.market_daily_change) < (s.strategy_filter * s.strategy_trigger_out))  then  
        m.market_override = 1
      end
      
      # Calculate market Switch
      if (m.market_override == 0) then
        m.market_switch = 'None'
      end
      
      if (m.market_in == 0) and (m.market_change_from_ref > s.strategy_trigger_in) then
        m.market_switch = 'In'
        m.market_last_switch_price = m.market_current_price
        m.market_last_switch_date  = m.market_current_date
        m.market_reference_price   = m.market_current_price
        m.market_reference_date    = m.market_current_date
      elsif (m.market_in == 1) and (m.market_change_from_ref < s.strategy_trigger_out) then
        m.market_switch = 'Out'
        m.market_last_switch_price = m.market_current_price
        m.market_last_switch_date  = m.market_current_date
        m.market_reference_price   = m.market_current_price
        m.market_reference_date    = m.market_current_date
      end
            
      if (m.market_switch == 'None') then
        if (m.market_in == 0) and (m.market_current_price < m.market_reference_price) then
          m.market_reference_price = m.current_reference_price
          m.market_reference_date  = m.market_current_date
        elsif (m.market_in == 1) and (m.market_current_price > m.market_reference_price) then
          m.market_reference_price = m.current_reference_price
          m.market_reference_date  = m.market_current_date
        end
      end 
    m.save  
    end
    @calculations['Markets with processing data'] = noMarkets
    
    respond_to do |format|
      format.html { render erb: @calculations } 
      format.json { render json: @calculations}
    end
   end
end
