# Exceptionally

[https://www.github.com/neilgupta/exceptionally](https://www.github.com/neilgupta/exceptionally)

## v1.4.4 (03/22/2021)

* Add Rails 6.1 support

## v1.4.3 (08/28/2020)

* Add Rails 6 support

## v1.4.2 (02/11/2017)

* Add Rails 5 support

## v1.4.1 (06/29/2016)

* Filter sensitive request parameters using Rails' filter_parameters list

## v1.4.0 (12/15/2015)

* Remove built-in support for `Pundit::NotAuthorizedError` errors

## v1.3.0 (10/24/2015)

* Pass the whole error object to `render_error` rather than just the error message, allowing for more customization of what's rendered. This is a **breaking change** if you depend on the old `render_error` or `pass_to_error_handler` methods!

## v1.2.0 (10/14/2015)

* Add built-in support for `Pundit::NotAuthorizedError` errors
* Drop vestigial development dependencies

## v1.1.0 (06/27/2015)

* Add built-in support for reporting to Sentry
* Add config option to enable/disable built-in error reporting
* Add specs

## v1.0.1 (06/10/2015)

* Change ApiPie::ParamInvalid to return status code 422 rather than the generic 400 code

## v1.0.0 (03/16/2014)

* Initial release
