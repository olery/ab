# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ab/version'

Gem::Specification.new do |gem|
  gem.name          = "ab"
  gem.version       = Ab::VERSION
  gem.authors       = ["sparkboxx", "giannismelidis"]
  gem.email         = ["wilcovanduinkerken@olery.com", "giannismelidis@olery.com"]
  gem.description   = %q{Basic AB testing gem}
  gem.summary       = %q{The gem provides a basic class Tester or view helper function ab that allows you to deterministically show a certain option (a/b/c/etc) to a user based on a certain chance (e.g. 1/5)}
  gem.homepage      = "http://github.com/olery/ab"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency("rspec")
end
