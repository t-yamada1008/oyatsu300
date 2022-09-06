require 'rails_helper'

RSpec.describe "Oyatsus", type: :request do
  describe "GET /index" do
    xit "returns http success" do
      get "/oyatsus/index"
      expect(response).to have_http_status(:success)
    end
  end

end
