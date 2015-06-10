module Exceptionally
  class Error < StandardError
    attr_reader :status

    def initialize(message = nil, status = nil, default = nil)
      @message = message
      @status = status || 500
      @default = default || "Internal Server Error"
    end

    def message
      @message || @default
    end

    def to_s
      "#{@status} #{@default}#{@message ? ": #{@message}" : ''}"
    end
  end

  class BadRequest < Error
    def initialize(message = nil)
      super(message, 400, "Bad Request")
    end
  end

  class Unauthorized < Error
    def initialize(message = nil)
      super(message, 401, "Unauthorized")
    end
  end

  class PaymentRequired < Error
    def initialize(message = nil)
      super(message, 402, "Payment Required")
    end
  end

  class Forbidden < Error
    def initialize(message = nil)
      super(message, 403, "Forbidden")
    end
  end

  class NotFound < Error
    def initialize(message = nil)
      super(message, 404, "Not Found")
    end
  end

  class NotAllowed < Error
    def initialize(message = nil)
      super(message, 405, "Method Not Allowed")
    end
  end

  class NotAcceptable < Error
    def initialize(message = nil)
      super(message, 406, "Not Acceptable")
    end
  end

  class ProxyAuthRequired < Error
    def initialize(message = nil)
      super(message, 407, "Proxy Authentication Required")
    end
  end

  class Timeout < Error
    def initialize(message = nil)
      super(message, 408, "Request Timeout")
    end
  end

  class Conflict < Error
    def initialize(message = nil)
      super(message, 409, "Conflict")
    end
  end

  class Gone < Error
    def initialize(message = nil)
      super(message, 410, "Gone")
    end
  end

  class LengthRequired < Error
    def initialize(message = nil)
      super(message, 411, "Length Required")
    end
  end

  class PreconditionFailed < Error
    def initialize(message = nil)
      super(message, 412, "Precondition Failed")
    end
  end

  class TooLarge < Error
    def initialize(message = nil)
      super(message, 413, "Request Entity Too Large")
    end
  end

  class TooLong < Error
    def initialize(message = nil)
      super(message, 414, "Request-URI Too Long")
    end
  end

  class UnsupportedMedia < Error
    def initialize(message = nil)
      super(message, 415, "Unsupported Media Type")
    end
  end

  class RangeNotSatisfiable < Error
    def initialize(message = nil)
      super(message, 416, "Requested Range Not Satisfiable")
    end
  end

  class ExpectationFailed < Error
    def initialize(message = nil)
      super(message, 417, "Expectation Failed")
    end
  end

  class UnprocessableEntity < Error
    def initialize(message = nil)
      super(message, 422, "Unprocessable Entity")
    end
  end

  class NotImplemented < Error
    def initialize(message = nil)
      super(message, 501, "Not Implemented")
    end
  end

  class BadGateway < Error
    def initialize(message = nil)
      super(message, 502, "Bad Gateway")
    end
  end

  class ServiceUnavailable < Error
    def initialize(message = nil)
      super(message, 503, "Service Unavailable")
    end
  end

  class GatewayTimeout < Error
    def initialize(message = nil)
      super(message, 504, "Gateway Timeout")
    end
  end

  class HttpVersionNotSupported < Error
    def initialize(message = nil)
      super(message, 505, "HTTP Version Not Supported")
    end
  end

  class Http400 < BadRequest; end
  class Http401 < Unauthorized; end
  class Http402 < PaymentRequired; end
  class Http403 < Forbidden; end
  class Http404 < NotFound; end
  class Http405 < NotAllowed; end
  class Http406 < NotAcceptable; end
  class Http407 < ProxyAuthRequired; end
  class Http408 < Timeout; end
  class Http409 < Conflict; end
  class Http410 < Gone; end
  class Http411 < LengthRequired; end
  class Http412 < PreconditionFailed; end
  class Http413 < TooLarge; end
  class Http414 < TooLong; end
  class Http415 < UnsupportedMedia; end
  class Http416 < RangeNotSatisfiable; end
  class Http417 < ExpectationFailed; end
  class Http422 < UnprocessableEntity; end
  class Http500 < Error; end
  class Http501 < NotImplemented; end
  class Http502 < BadGateway; end
  class Http503 < ServiceUnavailable; end
  class Http504 < GatewayTimeout; end
  class Http505 < HttpVersionNotSupported; end
end
