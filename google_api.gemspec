# -*- encoding: utf-8 -*-
require File.expand_path('../lib/google_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ondřej Moravčík"]
  gem.email         = ["moravcik.ondrej@gmail.com"]
  gem.description   = %q{Simple Google Api. Include google analytics.}
  gem.summary       = %q{Simple Google Api. Include google analytics.}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "google_api"
  gem.require_paths = ["lib"]
  gem.version       = GoogleApi::VERSION

  gem.add_dependency 'google-api-client'

  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec'
end
