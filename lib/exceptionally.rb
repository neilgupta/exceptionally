require 'exceptionally/controller'
require 'exceptionally/exceptions'
require 'exceptionally/handler'
require 'exceptionally/railtie'

module Exceptionally
  @@report_errors = Rails.env.production?

  def self.report_errors=(report_errors)
    @@report_errors = report_errors
  end

  def self.report_errors
    @@report_errors
  end
end
