# Exceptionally

[https://www.github.com/neilgupta/exceptionally](https://www.github.com/neilgupta/exceptionally)

[![Gem Version](https://badge.fury.io/rb/exceptionally.png)](http://badge.fury.io/rb/exceptionally)

Exceptionally abstracts your exception logic to make raising and returning meaningful errors in Ruby on Rails easier. It is primarily designed for API-only applications that need to return descriptive JSON error messages, rather than static HTML error pages.

Just raise the appropriate exception anywhere in your code and Exceptionally will handle the rest.

```ruby
raise Exceptionally::Unauthorized.new("Incorrect token")
```

will return the following JSON response to the client with a 401 status code: 

```javascript
{"error": "Incorrect token"}
```

It's that easy!

## Installation

To get started with Exceptionally, just add the following to your `Gemfile`:

```ruby
gem 'exceptionally'
```

Exceptionally has only been tested with Rails 4, but it should work with Rails 3+ in theory ;)

## Features

In addition to seamlessly abstracting your exception logic and returning clean JSON responses to your users, Exceptionally also offers the following benefits.

### Logging

If you raise a 500-level error, Exceptionally will log the error, stacktrace, and relevant parameters to Rails.logger. Additionally, Exceptionally supports [Airbrake](http://airbrake.io) and [New Relic](http://newrelic.com) by default, and will notify those services if you have their gems set up.

### Customizable

#### Add a custom error handler

Need to run your own logging code or do something else with the errors before they're returned to the user? Just add the following to `config/initializers/exceptionally.rb`:

```ruby
Exceptionally::Handler.before_render do |message, status, error, params|
  # Place your custom code here
  # message is a string description of what went wrong
  # status is an integer of the HTTP status code
  # error is a Ruby Exception object
  # params is a hash of the parameters passed to your controller
end
```

#### Override output formatting

You can also override the returned response by adding a `render_error` method to your controller. For example, if you want to include the HTTP status code in the returned JSON, you can do:

```ruby
def render_error(message, status)
  render json: {error_message: message, error_status: status}, status: status
end
```

You could also return HTML, XML, or whatever other format is relevant to your application.

`render_error` must accept `message`, a string description of the error, and `status`, an integer HTTP status code.

#### Add custom errors

Exceptionally will handle the following errors by default:

* generic Exceptions
* ArgumentErrors
* ActiveRecord::RecordNotFound
* ActiveRecord::RecordInvalid
* Apipie::ParamMissing (if using [Apipie](https://github.com/Apipie/apipie-rails))
* Apipie::ParamInvalid (if using [Apipie](https://github.com/Apipie/apipie-rails))
* Exceptionally errors (see below for available errors)

If there are additional errors that you want to assign status codes to and pass to Exceptionally, you can add the following to the top of your `application_controller.rb`:

```ruby
# Catch MyCustomModule::BadRequestException errors and pass them to Exceptionally
rescue_from MyCustomModule::BadRequestException, :with => :custom_400_error

# Tell Exceptionally you want this treated as a 400 error
def custom_400_error(error)
  pass_to_error_handler(error, 400)
end
```

`pass_to_error_handler` takes a Ruby Exception object and an optional status code. If no status code is provided, it will default to 500.

## Available Errors

You can raise the following HTTP errors. All of them accept an optional string that is passed to the user instead of the generic message (eg. "Invalid token" instead of "Unauthorized"):

* Exceptionally::BadRequest
* Exceptionally::Unauthorized
* Exceptionally::PaymentRequired
* Exceptionally::Forbidden
* Exceptionally::NotFound
* Exceptionally::NotAllowed
* Exceptionally::NotAcceptable
* Exceptionally::ProxyAuthRequired
* Exceptionally::Timeout
* Exceptionally::Conflict
* Exceptionally::Gone
* Exceptionally::LengthRequired
* Exceptionally::PreconditionFailed
* Exceptionally::TooLarge
* Exceptionally::TooLong
* Exceptionally::UnsupportedMedia
* Exceptionally::RangeNotSatisfiable
* Exceptionally::ExpectationFailed
* Exceptionally::Error
* Exceptionally::NotImplemented
* Exceptionally::BadGateway
* Exceptionally::ServiceUnavailable
* Exceptionally::GatewayTimeout
* Exceptionally::HttpVersionNotSupported

You can also raise an error with just the HTTP status code by using `Exceptionally::Http404`. Status codes 400-417 and 500-505 are available.

**[See descriptions of all status codes](http://www.w3.org/Protocols/rfc2616/rfc2616-sec10.html)**

## Why use Exceptionally?

By abstracting all of the exception handling logic, Exceptionally DRY's up your code and makes it easier to read. If you later decide to change the format of your error responses, you just need to edit `render_error` in one place. Exceptionally also transparently handles ActiveRecord, Apipie, and other generic exceptions for you, so that your app is less likely to crash. Additionally, you get a bunch of logging and error reporting functionality for free.

## Author

Neil Gupta [http://metamorphium.com](http://metamorphium.com)

## License

The MIT License (MIT) Copyright (c) 2014 Neil Gupta. See [MIT-LICENSE](https://raw.github.com/neilgupta/exceptionally/master/MIT-LICENSE)