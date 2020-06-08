require 'rails_helper'

RSpec.describe "Carts", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/carts/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/carts/new"
      expect(response).to have_http_status(:success)
    end
  end

end
