# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "nsa/version"

Gem::Specification.new do |spec|
  spec.name          = "nsa"
  spec.version       = ::NSA::VERSION
  spec.authors       = ["BJ Neilsen"]
  spec.email         = ["bj.neilsen@gmail.com"]

  spec.summary       = %q{Publish Rails application metrics to statsd}
  spec.description   = %q{Listen to your Rails ActiveSupport::Notifications and deliver to a Statsd compatible backend}
  spec.homepage      = "https://github.com/localshred/nsa"
  spec.licenses      = ["MIT"]

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "activesupport", "<= 7.2", ">= 4.2"
  spec.add_dependency "concurrent-ruby", "~> 1.0", ">= 1.0.2"
  spec.add_dependency "sidekiq", ">= 3.5"
  spec.add_dependency "statsd-ruby", "~> 1.4", ">= 1.4.0"

  spec.add_development_dependency "bundler", "~> 2.1"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
  spec.add_development_dependency "mocha", "~> 1.11"
  spec.add_development_dependency "byebug", "~> 10"
end
