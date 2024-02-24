class StocksController < ApplicationController
  def show
    ticker = params[:ticker]
    service = PolygonApiService.new()
    stock_data = service.fetch_stock_data(ticker, '2023-01-01', '2023-12-31')

    render json: stock_data
  end
end
