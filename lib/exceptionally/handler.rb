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
        # Support Airbrake and New Relic out of box
        Airbrake.notify(@error, :parameters => @params) if defined?(Airbrake) && Airbrake.respond_to?(:notify) && Rails.env.production?
        NewRelic::Agent.notice_error(@error) if defined?(NewRelic) && defined?(NewRelic::Agent) && NewRelic::Agent.respond_to?(:notice_error) && Rails.env.production?

        Rails.logger.error(@error.to_s)
        Rails.logger.error("Parameters: #{@params.to_s}") unless @params.blank?
        Rails.logger.error(@error.backtrace.join("\n")) unless @error.backtrace.blank?
      end
    end
  end  
end