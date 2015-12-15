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
      if defined?(Apipie)
        rescue_from Apipie::ParamMissing, :with => :missing_param
        rescue_from Apipie::ParamInvalid, :with => :invalid_param
      end
    end

    # Raise custom error
    def exceptionally_handler(error)
      pass_to_error_handler(error)
    end

    # Raise 400 error
    def missing_param(error)
      pass_to_error_handler(error, 400)
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
    def invalid_param(error)
      pass_to_error_handler(error, 422)
    end

    def pass_to_error_handler(error, status = nil)
      status ||= error.try(:status) || 500
      Exceptionally::Handler.new(error.message, status, error, params)
      render_error(error, status)
    end

    def render_error(error, status)
      render json: {error: error.message}, status: status
    end

  end
end
