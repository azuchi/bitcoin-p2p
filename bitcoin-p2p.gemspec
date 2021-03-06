require_relative 'lib/bitcoin/p2p/version'

Gem::Specification.new do |spec|
  spec.name          = "bitcoin-p2p"
  spec.version       = Bitcoin::P2P::VERSION
  spec.authors       = ["azuchi"]
  spec.email         = ["azuchi@chaintope.com"]

  spec.summary       = %q{Bitcoin p2p message repl tool.}
  spec.description   = %q{Bitcoin p2p message repl tool.}
  spec.homepage      = "https://github.com/azuchi/bitcoin-p2p"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage 

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "bin"
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency 'bitcoinrb', ">= 0.7.0"
end
