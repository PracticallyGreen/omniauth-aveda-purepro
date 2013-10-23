# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = 'omniauth-aveda-purepro'
  spec.version       = '1.0.0'
  spec.authors       = ['Rajiv Aaron Manglani']
  spec.email         = ['rajiv@practicallygreen.com']
  spec.description   = 'An OmniAuth strategy to authenticate against the proprietary Aveda PurePro JSON-RPC API.'
  spec.summary       = 'An OmniAuth strategy to authenticate against the proprietary Aveda PurePro JSON-RPC API.'
  spec.homepage      = 'https://github.com/PracticallyGreen/omniauth-aveda-purepro'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec', '~> 2.14'
  spec.add_development_dependency 'rack-test'

  spec.add_runtime_dependency 'faraday'
  spec.add_runtime_dependency 'multi_json'
  spec.add_runtime_dependency 'omniauth', '~> 1.1'
end
