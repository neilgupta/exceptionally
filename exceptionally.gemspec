$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "exceptionally/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "exceptionally"
  s.version     = Exceptionally::VERSION
  s.authors     = "Neil Gupta"
  s.email       = "neil@metamorphium.com"
  s.homepage    = "https://github.com/neilgupta/exceptionally"
  s.summary     = "Exceptionally simple Rails Exception library"
  s.description = "Exceptionally abstracts your exception logic to make raising and returning meaningful errors in Ruby on Rails easier."
  s.license     = 'MIT'

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 3.0.0", "< 5.0"

end
