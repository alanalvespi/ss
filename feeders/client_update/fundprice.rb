require "net/http"
require "uri"
require "../util/wa"


module FundPrice


  Price_cache = {}
  
  def FundPrice::Get(isin)
    # Get out of cache
    return Price_cache[isin] if Price_cache.has_key?(isin)
    
    # get from Internet
    url = "http://funds.ft.com/uk/Tearsheet/Summary?s=#{isin}"
    responce = Net::HTTP.get_response(URI.parse(url))
    data = responce.body
    if (data =~ /<td class="text first">([\d\.,]*)<\/td>/) then
      t = $1
      t = t.tr(',','')
      result = Float(t)
    else
      raise WaError.new("E-FundPrice:GetPriceFail, Failed to get price for #{isin}")
    end
    Price_cache[isin]=result
    return result 
  end
  
end


