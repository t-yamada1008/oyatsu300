require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /index" do
    xit "returns http success" do
      get "/users/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    xit "returns http success" do
      get "/users/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    xit "returns http success" do
      get "/users/new"
      expect(response).to have_http_status(:success)
    end
  end

end
