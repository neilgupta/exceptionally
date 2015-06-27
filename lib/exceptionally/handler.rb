module Exceptionally
  class Handler
    def initialize(message = nil, status = nil, e = nil, params = nil)
      @message = message
      @status = status || 500
      @error = e
      @params = params || {}

      @@callback.call(@message, @status, @error, @params) if defined?(@@callback) && @@callback.respond_to?(:call)
      
      log
    end

    def self.before_render(&block)
      @@callback = Proc.new(&block)
    end

    def log
      # Log 5xx errors
      if @status >= 500 && @error
        # Support Sentry, Airbrake, and New Relic out of box, but only in production
        if Exceptionally.report_errors
          Raven.capture_exception(@error) if defined?(Raven) && Raven.respond_to?(:capture_exception)
          Airbrake.notify(@error, :parameters => @params) if defined?(Airbrake) && Airbrake.respond_to?(:notify)
          NewRelic::Agent.notice_error(@error) if defined?(NewRelic) && defined?(NewRelic::Agent) && NewRelic::Agent.respond_to?(:notice_error)
        end

        Rails.logger.error(@error.to_s)
        Rails.logger.error("Parameters: #{@params.to_s}") unless @params.blank?
        Rails.logger.error(@error.backtrace.join("\n")) unless @error.backtrace.blank?
      end
    end
  end
end
