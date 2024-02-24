# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PolygonApiService do
  describe '#fetch_stock_data' do
    let(:service) { PolygonApiService.new }
    let(:ticker) { 'AAPL' }
    let(:from_date) { '2023-01-01' }
    let(:to_date) { '2023-01-31' }
    let(:api_response) do
      {
        'ticker' => ticker,
        'resultsCount' => 2,
        'results' => [
          {
            'v' => 100,
            'vw' => 150.0,
            'o' => 130.0,
            'c' => 140.0,
            'h' => 145.0,
            'l' => 125.0,
            't' => 1_700_000_000_000,
            'n' => 100
          },
          {
            'v' => 200,
            'vw' => 160.0,
            'o' => 135.0,
            'c' => 145.0,
            'h' => 150.0,
            'l' => 130.0,
            't' => 1_700_000_000_001,
            'n' => 200
          }
        ]
      }.to_json
    end

    before do
      stub_request(:get, "https://api.polygon.io/v2/aggs/ticker/#{ticker}/range/1/day/#{from_date}/#{to_date}?apiKey=#{ENV['POLYGON_API_KEY']}")
        .to_return(status: 200, body: api_response, headers: { 'Content-Type' => 'application/json' })
    end

    it 'fetches stock data and consolidates it' do
      consolidated_data = service.fetch_stock_data(ticker, from_date, to_date)
      expect(consolidated_data).to eq(
        [
          {
            item: "Price",
            maximum: 150.0,
            minimum: 125.0,
            average: 155.0
          },
          {
            item: "Volume",
            maximum: 200,
            minimum: 100,
            average: 150.0
          }
        ]
      )
    end

    before do
      stub_request(:get, "https://api.polygon.io/v2/aggs/ticker/NOEXISTE/range/1/day/2023-01-01/2023-01-31?apiKey=#{ENV['POLYGON_API_KEY']}")
        .to_return(
          status: 200,
          body: { resultsCount: 0 }.to_json,
          headers: { 'Content-Type' => 'application/json' }
        )
    end

    it 'returns an empty object for a ticker that does not exist' do
      service = PolygonApiService.new
      expect(service.fetch_stock_data('NOEXISTE', '2023-01-01', '2023-01-31')).to eq({})
    end
  end
end
