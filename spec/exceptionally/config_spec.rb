require 'spec_helper'

describe Exceptionally do
  it 'saves report_errors' do
    expect(Exceptionally.report_errors).to eq(Rails.env.production?)
    Exceptionally.report_errors = true
    expect(Exceptionally.report_errors).to eq(true)
    Exceptionally.report_errors = false
    expect(Exceptionally.report_errors).to eq(false)
  end
end

