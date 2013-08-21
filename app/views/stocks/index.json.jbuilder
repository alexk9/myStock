json.array!(@stocks) do |stock|
  json.extract! stock, 
  json.url stock_url(stock, format: :json)
end
