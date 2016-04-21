# coding: utf-8
$LOAD_PATH.push File.expand_path("../lib", __FILE__)
require "ablecop/version"

Gem::Specification.new do |spec|
  spec.name          = "ablecop"
  spec.version       = Ablecop::VERSION
  spec.authors       = ["Able Engineering"]
  spec.email         = ["engineering@able.co"]
  spec.summary       = ""
  spec.description   = ""
  spec.homepage      = "https://github.com/ableco/gems.able.co/able_cop"
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }
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

  # Fasterer will suggest some speed improvements.
  spec.add_dependency "fasterer"
  spec.add_dependency "pronto-fasterer"

  # SCSS Lint is a static code analyzer based on our SCSS style guide.
  spec.add_dependency "scss_lint"
  spec.add_dependency "pronto-scss"

  # Pronto runner for monitoring Rails schema.rb or structure.sql consistency.
  spec.add_dependency "pronto-rails_schema"
end
