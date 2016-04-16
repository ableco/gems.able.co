# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "ablecop/version"

Gem::Specification.new do |spec|
  spec.name          = "ablecop"
  spec.version       = Ablecop::VERSION
  spec.authors       = ["Mike Potter"]
  spec.email         = ["mike@able.co"]
  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = "https://github.com/ableco/gems.able.co/able_cop"
  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"

  # Pronto posts feedback from its runners to Github.
  spec.add_dependency "pronto", "~> 0.6.0"

  # Rubocop is a static code analyzer based on our Ruby style guide.
  spec.add_dependency "rubocop", "~> 0.39.0"
  spec.add_dependency "pronto-rubocop"

  # Brakeman scans for security vulenerabilities.
  spec.add_dependency "brakeman", "~> 3.2"
  spec.add_dependency "pronto-brakeman"

  # Monitor schema.rb for consistency with migrations.
  # spec.add_dependency "pronto-rails_schema"

  # Fasterer will suggest some speed improvements.
  spec.add_dependency "fasterer"
  spec.add_dependency "pronto-fasterer"

  # SCSS Lint is a static code analyzer based on our SCSS style guide.
  spec.add_dependency "scss_lint"
  spec.add_dependency "pronto-scss"
end
