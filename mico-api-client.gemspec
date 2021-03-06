# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mico/api/client/version'

Gem::Specification.new do |spec|
  spec.name          = "mico-api-client"
  spec.version       = Mico::Api::Client::VERSION
  spec.authors       = ["Marten Veldthuis"]
  spec.email         = ["marten@veldthuis.com"]

  spec.summary       = %q{Write a short summary, because Rubygems requires one.}
  spec.description   = %q{Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/zooniverse/mico-api-client"
  spec.license       = "Apache 2.0"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'ruby-progressbar'
  spec.add_development_dependency 'mongo'

  spec.add_dependency 'httparty'
  spec.add_dependency 'netrc'
end
