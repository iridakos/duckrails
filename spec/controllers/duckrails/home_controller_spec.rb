require 'rails_helper'

module Duckrails
  RSpec.describe HomeController, type: :controller do

    describe "GET #index" do
      it "returns http success" do
        get :index

        expect(response).to have_http_status(:success)
        expect(response).to render_template(:index)
      end
    end
  end
end
