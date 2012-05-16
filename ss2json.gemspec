# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ss2json/version"

Gem::Specification.new do |s|
  s.name        = "ss2json"
  s.version     = Ss2json::VERSION
  s.authors     = ["Guillermo Álvarez"]
  s.email       = ["guillermo@cientifico.net"]
  s.homepage    = ""
  s.summary     = %q{TODO: Write a gem summary}
  s.description = %q{TODO: Write a gem description}

  s.rubyforge_project = "ss2json"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "nested_hash"
  # specify any dependencies here; for example:
  # s.add_development_dependency "rspec"
  # s.add_runtime_dependency "rest-client"
end
