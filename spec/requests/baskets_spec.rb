require 'rails_helper'

RSpec.describe "Baskets", type: :request do
  describe "GET /index" do
    xit "returns http success" do
      get "/baskets/index"
      expect(response).to have_http_status(:success)
    end
  end

end
