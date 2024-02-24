require 'rails_helper'

RSpec.describe "Stocks", type: :request do
  describe "GET /show" do
    it "returns http success" do
      get "/stocks/show"
      expect(response).to have_http_status(:success)
    end
  end

end
