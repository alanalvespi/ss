require 'roo'
require 'iconv'

#
# Hack to close Roo work sheets
#
Excel.class_eval do
  def get_workbook
    @workbook
  end
end

Spreadsheet::Excel::Workbook.class_eval do
  def get_io
    @io
  end
end




class TestController < ApplicationController


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


  def generate_instructions
    # Dummy Routine::  simulates Generate Instructions to close the process...
    # Select all Markets that need instructions generated...
    test = Test.new
    @instructions = test.generate_instructions()
    #markets = Market.where("market_switch = 'Out' or market_switch = 'In'")
    #markets.each do |m|
    #  @instructions["#{m.market_id}"] = "#{m.market_switch}-->#{m.market_id}:#{m.market_friendly_name}[#{m.market_current_price}]" 
    #  if (m.market_switch == 'In') then
    #    m.market_in = 1
    #  else
    #    m.market_in = 0
    #  end
    #  m.market_switch = nil
    #  m.save
    #end  
    # 
    #if (@instructions.keys.length == 0) then
    #  @instructions['No'] = 'Instructions where generated'
    #end
    
    respond_to do |format|
      format.html { render  erb: @instructions} 
      format.json { render json: @instructions}
    end

  end

  def init_markets
    # Update SQL For Initial Market Reset...
    
    @test = Test.new()
    @test.init_markets('public/Test/TestData.xls','Markets Initial Entry','A','H')
    respond_to do |format|
      format.html { render text: @test.results.to_yaml.gsub("\n",'<br>')} 
    end

end


  
  def calculations
    @test = Test.new()
    @test.get_tests('public/Test/TestData.xls','Market Test Days','A','M')
    print "got Tests"
  end
  
  def uploadFile    
    File.open("public/Test/TestData.xls", "wb") { |f| f.write(params[:datafile].read) }
    print "File uploaded..."
    redirect_to "/Test/Calculations", :notice => "File uploaded at " + Time.now.to_s 
    #redirect_to post_url(@calculations), :status=> :found, :notice => "Pay attention to the road"
  end
  
  
  def full_calculations_test
  # Open TestData.xls
  # Execute all Tests defined there...
  
    @test = Test.new()
    @test.init_markets('public/Test/TestData.xls','Markets Initial Entry','A','H')
    @test.get_tests('public/Test/TestData.xls','Market Test Days','A','M')
    
    
    time = Benchmark.realtime do
      @test.exec_tests()
    end
    puts "Exec_tests took #{time}s"


    respond_to do |format|
      format.html { render  erb: @test} 
      format.json { render json: @test}
    end
  end

end