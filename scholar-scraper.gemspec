Gem::Specification.new do |spec|
  spec.name          = "scholar-scraper"
  spec.version       = "0.0.1"
  spec.authors       = ["Able.co"]
  spec.email         = ["cesar@able.co"]
  spec.description   = %q{Google Scholar scraper}
  spec.summary       = %q{Google Scholar scraper, allow searches scholar articles by author name.}
  spec.homepage      = "https://github.com/ableco/scholar-scraper"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'nokogiri', '~> 1.6.0'

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency 'rspec', '~> 2.13'
end
