require 'spec_helper'

describe ActionController, :type => :controller do
  controller do
    def index
      raise Exceptionally::Error.new
    end
  end

  before do
    routes.draw { get 'index' => "anonymous#index" }
    Rails.application.config.filter_parameters = [:password]
  end

  it 'filters password parameter' do
    temp_params = nil
    Exceptionally::Handler.before_render do |message, status, error, params|
      temp_params = params
    end

    get :index, params: {username: 'bob', password: '123456'}
    expect(temp_params['username']).to eq('bob')
    expect(temp_params['password']).to eq('[FILTERED]')
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
    temp_message = nil
    Exceptionally::Handler.before_render do |message, status, error, params|
      temp_message = message
    end

    get :index
    expect(temp_message).to eq('Internal Server Error')
  end

  it 'does not call handler before logging an error when none is proved' do
    temp_message = nil

    get :index
    expect(temp_message).to eq(nil)
  end
end
