require 'httparty'

class PolygonApiService
  include HTTParty
  base_uri 'https://api.polygon.io/v2'

  def initialize
    @api_key = 'taIMgMrmnZ8SUZmdpq9_7ANRDxw3IPIx'
  end

  def fetch_stock_data(ticker, from_date, to_date)
    response = self.class.get("/aggs/ticker/#{ticker}/range/1/day/#{from_date}/#{to_date}?apiKey=#{@api_key}")
    consolidate_data(response.parsed_response)
  end

  private
  def consolidate_data(stock_data)
    return {} if stock_data['resultsCount'] == 0

    max_high_price = stock_data['results'].first['h']
    min_low_price = stock_data['results'].first['l']
    max_volume = stock_data['results'].first['v']
    min_volume = stock_data['results'].first['v']
    total_volume = 0
    total_vw_price = 0


    stock_data['results'].each do |day|
      max_high_price = day['h'] if day['h'] > max_high_price
      min_low_price = day['l'] if day['l'] < min_low_price
      max_volume = day['v'] if day['v'] > max_volume
      min_volume = day['v'] if day['v'] < min_volume
      total_volume += day['v']
      total_vw_price += day['vw']
    end

    average_price = (total_vw_price / stock_data['results'].size).round(2)
    average_volume = (total_volume / stock_data['results'].size).round(2)

    [
      {
        "item": "Price",
        "maximum": max_high_price,
        "minimum": min_low_price,
        "average": average_price
      },
      {
        "item": "Volume",
        "maximum": max_volume,
        "minimum": min_volume,
        "average": average_volume
      }
    ]
  end
end
