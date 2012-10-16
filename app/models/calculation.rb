class Calculation
  # Simple Ruby class to execute the calculations...
  
  attr_accessor :calculations, :markets, :override, :in, :out, :none, :low, :high
  
  def labeled
    rv = {}
    rv['Markets processed']       = @markets
    rv['Markets with Override']   = @override.to_yaml
    rv['Markets with Switch In']  = @in.to_yaml
    rv['Markets with Switch Out'] = @out.to_yaml
    rv['Markets with New Low']    = @low.to_yaml
    rv['Markets with New High']   = @high.to_yaml
     
    return rv
  end  

  
  def initialize

    # Temporary Hack...  (only Strategy 1)    
    s = Strategies.find(1)
    
    # Select all Markets upon which to do the Switch calculation
    markets = Market.where("market_current_date > market_current_process_date")
    @markets = 0
    @override = {}
    @in = {}
    @out = {}
    @none = 0
    @low = {}
    @high = {}
    
    
    markets.each do | m |
      @markets += 1
      
      # Calculate Override... 
      if (m.market_current_price  and m.market_reference_price) then
        m.market_change_from_ref = (m.market_current_price / m.market_reference_price) - 1.0
      else 
        # m.market_change_from_ref = 0.0
        next
      end
      m.market_override = 0
      override_out= ((s.strategy_filter / 100.0 ) * (s.strategy_trigger_in  / 100.0))
      override_in = ((s.strategy_filter / 100.0 ) * (s.strategy_trigger_out / 100.0))
      
      if   ((m.market_in == 0) and (m.market_dailychange > override_out))  then   
        m.market_override = 1
        override_str = "Override [#{m.market_id}]:#{m.market_friendly_name}(#{m.market_dailychange} > #{override_out})"
      elsif ((m.market_in ==1) and (m.market_dailychange < override_in))  then  
        m.market_override = 1
        override_str = "Override [#{m.market_id}]:#{m.market_friendly_name}(#{m.market_dailychange} < #{override_in})"
      end
      
      # Calculate market Switch
      if (m.market_override == 0) then
        m.market_switch = 'None'
      end
      
      if (m.market_in == 0) and (m.market_change_from_ref > (s.strategy_trigger_in/100.0)) then
        if (m.market_override == 1) then 
          @override[m.market_id]=override_str;
        else
          m.market_switch = 'In'
          if (m.market_current_price > m.market_reference_price) then
            @high[m.market_id] = "High [#{m.market_id}]:#{m.market_friendly_name}(#{m.market_current_price})"
          end
          m.market_last_switch_price = m.market_current_price
          m.market_last_switch_date  = m.market_current_date
          m.market_reference_price   = m.market_current_price
          m.market_reference_date    = m.market_current_date
          m.market_in                = 1
          @in[m.market_id] = "BUY [#{m.market_id}]:#{m.market_friendly_name}(#{m.market_current_price})"
        end
      elsif (m.market_in == 1) and (m.market_change_from_ref < (s.strategy_trigger_out/100.0)) then
        if (m.market_override == 1) then 
          @override[m.market_id] = override_str
        else
          m.market_switch = 'Out'
          if (m.market_current_price < m.market_reference_price) then
            @low[m.market_id] = "Low [#{m.market_id}]:#{m.market_friendly_name}(#{m.market_current_price})"
          end
          m.market_last_switch_price = m.market_current_price
          m.market_last_switch_date  = m.market_current_date
          m.market_reference_price   = m.market_current_price
          m.market_reference_date    = m.market_current_date
          m.market_in                = 0
          @out[m.market_id] = "Sell [#{m.market_id}]:#{m.market_friendly_name}(#{m.market_current_price})"
        end
      end
            
      if (m.market_switch == 'None') then
        if (m.market_in == 0) and (m.market_current_price < m.market_reference_price) then
          m.market_reference_price = m.market_current_price
          m.market_reference_date  = m.market_current_date
          @low[m.market_id] = "Low [#{m.market_id}]:#{m.market_friendly_name}(#{m.market_current_price})"
        elsif (m.market_in == 1) and (m.market_current_price > m.market_reference_price) then
          m.market_reference_price = m.market_current_price
          m.market_reference_date  = m.market_current_date
          @high[m.market_id] = "High [#{m.market_id}]:#{m.market_friendly_name}(#{m.market_current_price})"
        end
        @none += 1
      end 
    m.save  
    end
  end
end
   