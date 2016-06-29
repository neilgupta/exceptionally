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

    get :index, username: 'bob', password: '123456'
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

  describe 'when only Raven is defined' do
    describe 'and report_errors is true' do
      before do
        Exceptionally.report_errors = true
      end

      it 'reports errors for a 500 error' do
        expect(Raven).to receive(:capture_exception)
        get :index
      end

      it 'does not report errors for a 400 error' do
        allow(controller).to receive(:index).and_raise(Exceptionally::BadRequest.new)

        expect(Raven).to_not receive(:capture_exception)
        get :index
      end

      it 'does not report errors to Airbrake' do
        expect(Airbrake).to receive(:respond_to?).at_least(:once)
        expect(Airbrake).to_not receive(:notify)

        get :index
      end
    end

    describe 'and report_errors is false' do
      before do
        Exceptionally.report_errors = false
      end

      it 'does not report errors for a 500 error' do
        expect(Raven).to_not receive(:capture_exception)
        get :index
      end
    end
  end
end
