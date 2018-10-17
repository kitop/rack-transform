$:.push File.expand_path("../lib", __FILE__)

require "rack/transform/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rack-transform"
  s.version     = Rack::Transform::VERSION
  s.authors     = ["Esteban Pastorino"]
  s.email       = ["ejpastorino@gmail.com"]
  s.homepage    = "http://github.com/kitop/rack-transform"
  s.summary     = "Transform Rack request and responses on the fly."
  s.description = "Rack::Transform is a middleware that attemps to make a compatibility layer between two different request/responses that should hit the same endpoint."
  s.license     = "MIT"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rack", ">= 1.5.0", "< 3.0"

  s.add_development_dependency "rake"
  s.add_development_dependency "rspec", "~> 3.2", ">= 3.2.0"
end

