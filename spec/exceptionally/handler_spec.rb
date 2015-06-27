require 'spec_helper'

describe ActionController, :type => :controller do
  controller do
    def index
      raise Exceptionally::Error.new
    end
  end

  before do
    routes.draw { get 'index' => "anonymous#index" }
  end

  it 'logs 5xx errors' do
    expect(Rails.logger).to receive(:error).with('500 Internal Server Error').once
    expect(Rails.logger).to receive(:error).exactly(2).times
    get :index
  end

  it 'logs 5xx errors with a custom error message' do
    allow(controller).to receive(:index).and_raise(Exceptionally::BadGateway.new('some custom error'))

    expect(Rails.logger).to receive(:error).with('502 Bad Gateway: some custom error').once
    expect(Rails.logger).to receive(:error).exactly(2).times
    get :index
  end

  it 'does not log 4xx errors' do
    allow(controller).to receive(:index).and_raise(Exceptionally::BadRequest.new)

    expect(Rails.logger).to_not receive(:error)
    get :index
  end

  it 'calls handler before logging an error when set' do
    temp_var = nil
    Exceptionally::Handler.before_render do |message, status, error, params|
      temp_var = message
    end

    get :index
    expect(temp_var).to eq('Internal Server Error')
  end

  it 'does not call handler before logging an error when none is proved' do
    temp_var = nil

    get :index
    expect(temp_var).to eq(nil)
  end
end
