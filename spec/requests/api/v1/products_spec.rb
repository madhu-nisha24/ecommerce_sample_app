require 'rails_helper'

RSpec.describe "Api::V1::Products", type: :request do
  describe "GET /index" do
    let!(:product1) { create(:product, name: 'Apple', category_id:1) }
    let!(:product2) { create(:product, name: 'Banana', category_id:1) }
    let!(:product3) { create(:product, name: 'Grapes', category_id:1) }

    describe "GET /api/v1/products" do
    context 'when there is a search query' do
      before do
        get api_v1_products_path, headers: { "ACCEPT" => "application/json" }
      end

      it 'returns the products as JSON' do
        expect(response.content_type).to include("application/json")
        json_response = JSON.parse(response.body)
        expect(json_response).to match_array([
                                               { 'id' => product1.id, 'name' => product1.name },
                                               { 'id' => product2.id, 'name' => product2.name },
                                               { 'id' => product3.id, 'name' => product3.name }
                                             ])
      end
      # it 'does not return products that do not match the query' do
      #   expect(json_response).not_to include([{
      #                                           'id' => product1.id,
      #                                           'name' => product1.name,
      #                                           'quantity' => product1.quantity,
      #                                           'category_id' => product1.category_id,
      #                                           'created_at' => product1.created_at.as_json,
      #                                           'updated_at' => product1.updated_at.as_json
      #                                         }])
      #   #expect(JSON.parse(response.body)).not_to include({'name' => product2.name}, {'name' => product3.name})
      # end
    end

    # context 'when there is no search query' do
    #   before do
    #     get api_v1_products_path
    #   end
    #
    #   it 'returns all products' do
    #     expect(JSON.parse(response.body).map { |p| p['name'] }).to match_array([product1.name, product2.name, product3.name])
    #   end
    # end
  end
  end
  end
