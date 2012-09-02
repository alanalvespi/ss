require "net/http"
require "uri"

module ExchangeRate
  Xrate_cache = {}
  
  def ExchangeRate::Get(fund_currency,policy_currency)
    # same currency?
    return 1.0 if fund_currency == policy_currency
  
    # get from cache
    ckey = "#{fund_currency}:#{policy_currency}"
    return Xrate_cache[ckey] if Xrate_cache.has_key?(ckey)
    
    # get From Internet
    url = "http://www.google.com/ig/calculator?hl=en&q=1#{fund_currency}%20in%20#{policy_currency}"
    responce = Net::HTTP.get_response(URI.parse(url))
    data = responce.body
    if (data =~ /rhs: "([\d.]*)/) then
      result = $1.to_f
    else
      raise "XRATE:Failed to get exchange rate for #{fund_currency}/#{policy_currency}"
    end
    Xrate_cache[ckey] = result
    return result 
  end
end