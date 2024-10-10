require 'net/http'
require 'json'

module LatestStockPrice
  class Client
    BASE_URL = "https://rapidapi.com/suneetk92/api/"

    def initialize(api_key)
      @api_key = api_key
      @headers = {
        "x-rapidapi-host" => "rapidapi.com",
        "x-rapidapi-key" => @api_key
      }
    end
    
    def price_all
      endpoint = "/latest-stock-price"
      get_request(endpoint)
    end

    private

    def get_request(endpoint, params = {})
      uri = URI(BASE_URL + endpoint)
      uri.query = URI.encode_www_form(params) unless params.empty?
      response = Net::HTTP.get_response(uri, @headers)
      parse_response(response)
    end

    def parse_response(response)
      case response
      when Net::HTTPSuccess
        JSON.parse(response.body)
      else
        raise "API Request failed with status #{response.code}: #{response.message}"
      end
    end
  end
end
