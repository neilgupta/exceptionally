require 'spec_helper'

describe ActionController, :type => :controller do
  controller do
    def index
      raise ArgumentError.new('some error')
    end
  end

  before do
    routes.draw { get 'index' => "anonymous#index" }
  end

  describe "when a controller raises an error" do
    it 'returns a JSON error message with 500 status' do
      get :index
      expect(response.status).to eq(500)
      expect(JSON.parse(response.body)['error']).to eq('some error')
    end

    it 'returns a 404 response when a record is not found' do
      allow(controller).to receive(:index).and_raise(ActiveRecord::RecordNotFound.new)

      get :index
      expect(response.status).to eq(404)
      expect(JSON.parse(response.body)['error']).to eq('ActiveRecord::RecordNotFound')
    end

    it 'returns a 403 response when Forbidden' do
      allow(controller).to receive(:index).and_raise(Exceptionally::Forbidden.new)

      get :index
      expect(response.status).to eq(403)
      expect(JSON.parse(response.body)['error']).to eq('Forbidden')
    end
  end
end
