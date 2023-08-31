require "active_record/validations.rb"

module Exceptionally
  module Controller
    extend ActiveSupport::Concern

    included do
      rescue_from Exception, :with => :exceptionally_handler
      rescue_from ArgumentError, :with => :exceptionally_handler
      rescue_from Exceptionally::Error, :with => :exceptionally_handler
      rescue_from ActiveRecord::RecordNotFound, :with => :missing_record_handler
      rescue_from ActiveRecord::RecordInvalid, :with => :record_invalid_handler
      rescue_from ActiveRecord::RecordNotSaved, :with => :record_not_saved
    end

    # Raise custom error
    def exceptionally_handler(error)
      pass_to_error_handler(error)
    end

    # Raise 404 error
    def missing_record_handler(error)
      pass_to_error_handler(error, 404)
    end

    # Raise 409 error
    def record_invalid_handler(error)
      pass_to_error_handler(error, 409)
    end

    # Raise 422 error
    def record_not_saved(error)
      pass_to_error_handler(error, 422, {validations: error.record.try(:errors)})
    end

    def pass_to_error_handler(error, status = nil, extra = {})
      status ||= error.try(:status) || 500
      Exceptionally::Handler.new(error.message, status, error, params)
      render_error(error, status, extra)
    end

    def render_error(error, status = 500, extra = {})
      render json: {error: error.message}.merge(extra || {}), status: status || 500
    end

  end
end
