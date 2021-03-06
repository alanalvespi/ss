class Test
  # Simple object to hold tests...
  attr_accessor :tests, :results
  
  def initialize()
    # Create an Object and executed tests...
  end
  
  def _getExcelSheet(filename,sheetname,from,to)
    # json is not any faster than excel...
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
        market.market_in                    = 0
        market.market_in                    = 1 if (vals['IN/OUT'] == 'IN')
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

      # setup storage for new test...
      ds = d
      ds = d.strftime("%Y-%m-%d") if (d.class == Date)
      year, month, day = ds.split('-')
      data_files = {'AC.xls'  => "/data/feeders/market_update/#{year}/#{month}/#{day}/AC.xls",
                    'DM.xls'  => "/data/feeders/market_update/#{year}/#{month}/#{day}/DM.xls",
                    'EMxls'   => "/data/feeders/market_update/#{year}/#{month}/#{day}/EM.xls",
                    'SC.xls'  => "/data/feeders/market_update/#{year}/#{month}/#{day}/SC.xls",
                    'log.txt' => "/data/feeders/market_update/#{year}/#{month}/#{day}/market_update_log.txt"
                   } 
      unless (@tests.has_key?(ds)) then
        @tests[ds] = {'data_files'=>data_files}
        @tests[ds]['expected'] = []
      end

      # identify the type of result to be tested
      vals['Type'] = ''
      if (vals['BUY or SELL'] == 'BUY' or vals['BUY or SELL'] == 'SELL') then
        t = vals.clone
        t['Type'] = t['BUY or SELL']
        @tests[ds]['expected'].push(t)
      end
          
      if (vals['HIGH/LOW'] == 'LOW' or vals['HIGH/LOW'] == 'HIGH') then
        t = vals.clone
        t['Type'] = t['HIGH/LOW']
        @tests[ds]['expected'].push(t)
      end
        
      if (vals['Override'] == 'Override') then
        t = vals.clone
        t['Type'] = t['Override']
        @tests[ds]['expected'].push(t)
      end
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
      
      
      # check that each result actually happened
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
        when 'SELL'
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
          errors.push("Unexpected Override #{calculation.override[mid]}")          
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
  
  def delete_database()
    tables = ['policyfunds',
              'currencies',
              'strategies_markets',
              'policies',
              'clients',
              'plantype_strategies',
              'plantypestrategyfunds',
              'plantypes',
              'plantypefunds',
              'markets',
              'strategies',
              'companies',
              'products'
             ]

    # Delete all data from all tables...             
    #ActiveRecord::Base.transaction do
      tables.each do |tab|
        ActiveRecord::Base.connection.execute("Delete from #{tab};")
      end
    #end             
      @results = {'result'=> "Deleted all rows from #{tables.join(', ')}"}
                 
  end
  
  def init_database(filename)
    delete_database()
    @results = {}
                    
    no_markets = 0
    # Load Excel
    now = Date.today()
    sheets = _getExcel(filename)
    sheets.keys.each do |sname|
      sheet = sheets[sname]
      @results[sname] = 0 unless @results.has_key?(sname)
      puts "Table #{sname}"
      
      begin 
        case sname
  
        when 'markets'
          sheet.each do |row|
            m = Market.new()
            row.keys.each { |n| m[n] = row[n] unless (n[0] == '_') }
            m.created_at = now
            m.updated_at = now
            m.save
            @results[sname] = @results[sname] + 1
          end
  
        when 'companies'
          sheet.each do |row|
            m = Company.new()
            row.keys.each { |n| m[n] = row[n] unless (n[0] == '_') }
            m.created_at = now
            m.updated_at = now
            m.save
            @results[sname] = @results[sname] + 1
          end
          
        when 'products'
          sheet.each do |row|
            m = Product.new()
            row.keys.each { |n| m[n] = row[n] unless (n[0] == '_') }
            m.save
            @results[sname] = @results[sname] + 1
          end
          
        when 'plantypes'
          sheet.each do |row|
            m = Plantype.new()
            row.keys.each { |n| m[n] = row[n] unless (n[0] == '_') }
            m.save
            @results[sname] = @results[sname] + 1
          end
          
        when 'plantypefunds'
          sheet.each do |row|
            m = Plantypefunds.new()
            row.keys.each { |n| m[n] = row[n] unless (n[0] == '_') }
            m.save
            @results[sname] = @results[sname] + 1
          end
          
        when 'strategies'
          sheet.each do |row|
            m = Strategy.new()
            row.keys.each { |n| m[n] = row[n] unless (n[0] == '_') }
            m.save
            @results[sname] = @results[sname] + 1
          end
          
        when 'plantype_strategies'
          sheet.each do |row|
            m = Plantype_strategy.new()
            row.keys.each { |n| m[n] = row[n] unless (n[0] == '_') }
            m.save
            @results[sname] = @results[sname] + 1
          end
          
        when 'plantypestrategyfunds'
          sheet.each do |row|
            m = Plantypestrategyfunds.new()
            row.keys.each { |n| m[n] = row[n] unless (n[0] == '_') }
            m.save
            @results[sname] = @results[sname] + 1
          end
          
        end
      rescue
        @results['errors'] = "Error inserting #{@results[sname] + 1} element into #{sname}"
        @results['Reason'] = "#{$!}"
        puts  @results['errors'] 
      end
      
    end              
  end

     

  def _getExcel(filename)
    # json is not any faster than excel...
    sheets = {}
    

    book = Excel.new(filename)
    book.sheets.each do | sname |
      rows =[]
      book.default_sheet = sname
      first_row = book.first_row
      last_row  = book.last_row
      from      = book.first_column_as_letter
      to        = book.last_column_as_letter
      first_cell = nil
      colheads = nil
      # Loop over all Rows...
      first_row.upto(last_row) do |row|
        first_cell = book.cell(row,'A')
        next unless (first_cell)
        
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
      sheets[sname] = rows      
    end
    book.get_workbook.get_io.close  # Added close to Excel workbook
    return sheets
  end

  
end