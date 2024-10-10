require 'net/http'
require 'json'

class LatestStockPrice
  BASE_URL = 'https://api.example.com/stocks' # Ganti dengan URL API yang sesuai

  def self.fetch(stock_symbol)
    url = URI("#{BASE_URL}/#{stock_symbol}/latest")
    response = Net::HTTP.get(url)
    parse_response(response)
  end

  private

  def self.parse_response(response)
    data = JSON.parse(response)

    # Pastikan struktur data sesuai dengan yang dikembalikan oleh API
    if data['price']
      {
        symbol: data['symbol'],
        price: data['price'],
        timestamp: data['timestamp']
      }
    else
      { error: 'Data not available' }
    end
  end
end
