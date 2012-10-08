class Test
  # Simple object to hold tests...
  attr_accessor :tests, :results
  
  def initialize()
    # Create an Object and executed tests...
  end
  
  def _getExcelSheet(filename,sheetname,from,to)
    rows =[]
      book = Excel.new(filename)
      book.default_sheet = sheetname
      first_row = book.first_row
      last_row  = book.last_row
      first_cell = nil
      colheads = nil
      # Loop over all Rows...
      first_row.upto(last_row) do |row|
        first_cell = book.cell(row,'A')
        next unless(first_cell)  # Skip Rows with empty col "A"
        
        unless (colheads) then
          colheads = {}
          from.upto(to) do |col|
            colheads[col] = book.cell(row,col)
          end
          next          
        end
        
        vals ={}
        from.upto(to) do |col|
          head = colheads[col]
          value = book.cell(row,col)
          vals[head] = value
        end
        rows.push(vals)
      end      
      book.get_workbook.get_io.close  # Added close to Excel workbook
    return rows
  end


  
  def init_markets(excelName,sheetName,fromCol,toCol)
    # Update SQL For Initial Market Reset...
    
    @results = {}

    rows = _getExcelSheet(excelName,sheetName,fromCol,toCol)
    rows.each do | vals |
      begin
        # Update Database with this row...
        mid = Integer(vals['Market ID'])
        market = Market.find(mid)
        market.market_in                    = vals['IN/OUT']
        market.market_reference_price       = vals['Ref price']
        market.market_reference_date        = vals['Ref date']
        market.market_last_switch_price     = vals['Switch price']
        market.market_last_switch_date      = vals['Switch date']
        market.market_current_process_date  = vals['market_current_process_date']
        # markets.market_current_process_date = '2011-12-31'  No longer required as first Market day is initial setting...
        market.save
        @results[mid] = "Okay:#{vals}"
      rescue 
        err = $!
        @results[mid] = "#{err}:#{vals}"
      end
    end
  end  
  
  def get_tests(excelName,sheetName,fromCol,toCol)
    
    @tests = {}
    rows = _getExcelSheet(excelName,sheetName,fromCol,toCol)
    rows.each do |vals|
      d = vals['Date']

      # Correct Override Flag...
      override = ''
      case vals['Override']
        when -1  ; override = 'Override'
        when 'Y' ; override = 'Override'
        when 'y' ; override = 'Override'
      end  
      vals['Override'] = override 
      vals['Market ID'] = Integer(vals['Market ID'])


      # identify the type of result to be tested
      vals['Type'] = ''
      vals['Type'] = vals['BUY or SELL'] if (vals['BUY or SELL'] == 'BUY' or vals['BUY or SELL'] == 'SELL') 
      vals['Type'] = vals['HIGH/LOW'] if (vals['HIGH/LOW'] == 'LOW' or vals['HIGH/LOW'] == 'HIGH') 
      vals['Type'] = vals['Override'] if (vals['Override'] == 'Override') 

      ds = d.strftime("%Y-%m-%d")
      unless (@tests.has_key?(ds)) then
        @tests[ds] = {}
        @tests[ds]['expected'] = []
      end
      @tests[ds]['expected'].push(vals)
    end  
  end

  def exec_tests
    #@tests['RC'] = "Test was Succesfully completed"
    step = 1
    @tests.keys.sort.each do |d|
      step += 1
      test = @tests[d]['expected']
      result = []
      errors = []
      timings = []
      geninstruction = false
      
      market_update = nil
      time = Benchmark.realtime do
        market_update = Feeder.new('market_update',d)
      end
      timings.push("Market Update took #{time}s")
      
      calculation = nil
      time = Benchmark.realtime do
        calculation   = Calculation.new()
      end
      timings.push("Switch Calculation took #{time*1000}ms")
      
      
      # check that each result is actually happened
      test_list = {}
      test.each do |r|
        ident = "#{r['Market ID']}:#{r['Market']}"
        mid = r['Market ID']
        case r['Type']
        when 'BUY'        
          if calculation.in.has_key?(mid) then
            result.push(calculation.in[mid])
            geninstruction = true
          else
            errors.push("Missing BUY #{ident} ")
          end 
        when 'Sell'
          if calculation.out.has_key?(mid) then
            result.push(calculation.out[mid])
            geninstruction = true
          else
            errors.push("Missing SELL #{ident}")
          end 
        when 'HIGH';          
          if calculation.high.has_key?(mid) then
            result.push(calculation.high[mid])
          else
            errors.push("Missing High #{ident}")
          end 
        when 'LOW'          
          if calculation.low.has_key?(mid) then
            result.push(calculation.low[mid])
          else
            errors.push("Missing LOW #{ident}")
          end 
        when 'Override'          
          if calculation.override.has_key?(mid) then
            result.push(calculation.override[mid])
          else
            errors.push("Missing Override #{ident}")
          end 
        end
        test_list[mid] = r unless (r['Type'] == '') 
      end
      
      # Check that all buys are expected
      calculation.in.keys.each do |mid|
        unless test_list.has_key?(mid) then
          errors.push("Unexpected #{calculation.in[mid]}") 
        end
      end 
      
      calculation.out.keys.each do |mid|
        unless (test_list.has_key?(mid)) then
          errors.push("Unexpected #{calculation.out[mid]}")
        end
      end 

      calculation.high.keys.each do |mid|
        unless (test_list.has_key?(mid)) then
          errors.push("Unexpected #{calculation.high[mid]}")
        end
      end 
       
      calculation.low.keys.each do |mid| 
        unless (test_list.has_key?(mid)) then
          errors.push("Unexpected #{calculation.low[mid]}")
        end
      end
      
      calculation.override.keys.each do |mid| 
        unless (test_list.has_key?(mid)) then
          errors.push("Unexpected Override #{mid}")          
        end
      end      
      
      
      @tests[d]['result'] = result 
      @tests[d]['errors'] = errors 
      rc = errors.length
      @tests[d]["rc"] = "Test Date #{d} has #{rc} errors" 
      @tests[d]["timings"] = timings 
      return rc if (rc != 0)
      
      # do generation instruction if required
      
      @tests[d]['instructions'] = generate_instructions() if (geninstruction)
    end
  end
  
  def generate_instructions  
    markets = Market.where("market_switch = 'Out' or market_switch = 'In'")
    instructions = {}
    markets.each do |m|
      instructions["#{m.market_id}"] = "#{m.market_switch}-->#{m.market_id}:#{m.market_friendly_name}[#{m.market_current_price}]" 
      if (m.market_switch == 'In') then
        m.market_in = 1
      else
        m.market_in = 0
      end
      m.market_switch = nil
      m.save
    end  
    
    if (instructions.keys.length == 0) then
      instructions['No'] = 'Instructions where generated'
    end
    return instructions
  end
  
end