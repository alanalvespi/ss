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

  def generate_instructions
    # Dummy Routine::  simulates Generate Instructions to close the process...
    @calculations = {};
    # Select all Markets that need instructions generated...
    markets = Market.where("market_switch = 'Out' or market_switch = 'In'")
    markets.each do |m|
      @calculations["#{m.market_id}"] = "#{m.market_switch}-->#{m.market_id}:#{m.market_friendly_name}[#{m.market_current_price}]" 
      if (m.market_switch == 'In') then
        m.market_in = 1
      else
        m.market_in = 0
      end
      m.market_switch = nil
      m.save
    end  
    
    if (@calculations.keys.length == 0) then
      @calculations['No'] = 'Instructions where generated'
    end
    respond_to do |format|
      format.html { render template: 'calculations/switch', erb: @calculations} 
      format.json { render json: @calculations}
    end

  end

  def init_markets
    # Update SQL For Initial Market Reset...
    
    @calculations = {}
    book = Excel.new('public/Test/TestData.xls')
    book.default_sheet = 'Markets Initial Entry'
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
        'A'.upto('J') do |col|
          colheads[col] = book.cell(row,col)
        end
        next          
      end
      
      vals = {}
      'A'.upto('G') do |col|
        head = colheads[col]
        value = book.cell(row,col)
        vals[head] = value
      end

      begin
        # Update Database with this row...
        mid = Integer(vals['Market ID'])
        market = Market.find(mid)
        market.market_in                    = vals['IN/OUT']
        market.market_reference_price       = vals['Ref price']
        market.market_reference_date        = vals['Ref date']
        market.market_last_switch_price     = vals['Switch price']
        market.market_last_switch_date      = vals['Switch date']
        # markets.market_current_process_date = '2011-12-31'  No longer required as first Market day is initial setting...
        market.save
        @calculations[mid] = "Okay:#{vals}"
      rescue 
        err = $!
        @calculations[mid] = "#{err}:#{vals}"
      end

    end  
    book.get_workbook.get_io.close  # Added close to Excel workbook      

    respond_to do |format|
      format.html { render template: 'calculations/switch', erb: @calculations} 
      format.json { render json: @calculations}
    end

  end


  
  def calculations
    @calculations = {}   
    book = Excel.new('public/Test/TestData.xls')
    book.default_sheet = 'Market Test Days'
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
        'A'.upto('J') do |col|
          colheads[col] = book.cell(row,col)
        end
        next          
      end
      
      vals = {}
      'A'.upto('J') do |col|
        head = colheads[col]
        value = book.cell(row,col)
        vals[head] = value
      end
      d = vals['Date']
      
      unless (@calculations.has_key?(d)) then
        @calculations[d] = []
      end
      @calculations[d].push(vals)
    end  
    book.get_workbook.get_io.close  # Added close to Excel workbook

  end
  
  
end