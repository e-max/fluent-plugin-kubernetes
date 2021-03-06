# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "fluent-plugin-kubernetes"
  spec.version       = File.read("VERSION").strip
  spec.authors       = ["Max Lavrenov"]
  spec.email         = ["max.lavrenov@gmail.com"]
  spec.description   = %q{fluentd output filter plugin compatible with kubernetes.}
  spec.summary       = spec.description
  spec.license       = "MIT"
  spec.has_rdoc      = false

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake", "~> 10.4.2"

  spec.add_dependency "fluentd", "~> 0.10.17"
end
