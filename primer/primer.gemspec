# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'primer/version'
require 'date'

Gem::Specification.new do |s|
  s.required_ruby_version = ">= #{Primer::RUBY_VERSION}"
  s.authors = ["Able Engineering"]
  s.date = Date.today.strftime('%Y-%m-%d')

  s.description = <<-HERE
Primer is a base Rails project that you can upgrade. It is used by
Able to get a jump start on a working app. It owes a HUGE debt to
the Suspenders gem created by thoughtbot.
  HERE

  s.email = 'engineering@able.co'
  s.executables = ['primer']
  s.extra_rdoc_files = %w[README.md]
  s.files = `git ls-files`.split("\n")
  s.homepage = 'http://github.com/ableco/primer'
  s.license = 'MIT'
  s.name = 'primer'
  s.rdoc_options = ['--charset=UTF-8']
  s.require_paths = ['lib']
  s.summary = "Generate a Rails app using Able's best practices."
  s.test_files = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.version = Primer::VERSION

  s.add_dependency 'bundler', '~> 1.3'
  s.add_dependency 'rails', Primer::RAILS_VERSION

  s.add_development_dependency 'rspec', '~> 3.2'
end
