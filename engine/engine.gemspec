# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "engine"
  spec.version       = '1.0'
  spec.authors       = ["Vinicius J. S. Souza"]
  spec.email         = ["viniciusjssouza@gmail.com"]
  spec.summary       = %q{Engine for the Minesweeper Game}
  spec.license       = "MIT"

  spec.files         = ['lib/*']
#  spec.executables   = ['']
  spec.test_files    = ['tests/*']
  spec.require_paths = ["lib"]
end
