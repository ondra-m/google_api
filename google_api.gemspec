# -*- encoding: utf-8 -*-
require File.expand_path('../lib/google_api/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Ondřej Moravčík"]
  gem.email         = ["moravcik.ondrej@gmail.com"]
  gem.description   = %q{Google Api}
  gem.summary       = %q{Google Api}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "google_api"
  gem.require_paths = ["lib"]
  # gem.version       = GoogleApi::VERSION
  gem.version       = GoogleApi::VERSION + "." + Time.now.strftime("%Y%m%d%H%M%S")
end
