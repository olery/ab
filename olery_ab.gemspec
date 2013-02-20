# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'olery_ab/version'

Gem::Specification.new do |gem|
  gem.name          = "olery_ab"
  gem.version       = Olery::AB::VERSION
  gem.authors       = ["sparkboxx", "giannismelidis"]
  gem.email         = ["wilcovanduinkerken@olery.com"]
  gem.description   = %q{Very basic AB testing in Olery}
  gem.summary       = %q{Take a look at the description}
  gem.homepage      = "http://github.com/olery/olery_ab"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("rspec")
end
