require 'rubygems'
require 'roo'


module RL360_ISIN
  
  # @note: get hard wired ISINs stored in excel file
  RL360_ISIN::ISINS = {}
  
  def RL360_ISIN::Load
    filename = 'FundIsin.xls'
    book = Excel.new(filename)
      book.default_sheet = book.sheets.first
      last_row  = book.last_row
    
      # Loop over all Rows...
      2.upto(last_row) do |row|
        code = book.cell(row,'A')
        code_i = code.to_i
        code = "#{code_i}" unless (code_i == 0)
        RL360_ISIN::ISINS[code] = book.cell(row,'D') 
        # puts "#{code}:#{book.cell(row,'D')}"
      end
    end
end
