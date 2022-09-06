require 'rails_helper'

RSpec.describe "Admin::Boards", type: :request do
  describe "GET /index" do
    xit "returns http success" do
      get "/admin/boards/index"
      expect(response).to have_http_status(:success)
    end
  end

end
