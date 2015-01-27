# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'remote_zip/version'

Gem::Specification.new do |spec|
  spec.name          = "remote_zip"
  spec.version       = RemoteZip::VERSION
  spec.authors       = ["Artur Hebda"]
  spec.email         = ["arturhebda@gmail.com"]
  spec.summary       = %q{Iterate over extracted files from a downloaded zip file without a hassle.}
  spec.description   = %q{Zip is written to a tempfile and its content to a directory
                          named after the tempfile, so it stays unique.
                          Content is yielded as open files with logical paths.}
  spec.homepage      = "https://github.com/aenain/remote_zip"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rubyzip", "~> 1.1"

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "webmock", "~> 1.18"
end
