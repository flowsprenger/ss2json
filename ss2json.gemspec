# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "ss2json/version"

Gem::Specification.new do |s|
  s.name        = "ss2json"
  s.version     = SS2JSON::VERSION
  s.authors     = ["Guillermo Álvarez"]
  s.email       = ["guillermo@cientifico.net"]
  s.homepage    = ""
  s.summary     = %q{SpreadSheet to Json convert}
  s.description = %q{Convert SpreadSheet documents to json following some conventions.}

  s.rubyforge_project = "ss2json"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.add_runtime_dependency "nested_hash"
  s.add_runtime_dependency "roo"
  s.add_runtime_dependency "terminal-table"
  s.add_runtime_dependency "json"
  s.add_runtime_dependency "system_timer"

  s.add_development_dependency "ronn"
  s.add_development_dependency "rake"
  s.add_development_dependency "ruby-debug"

#   s.post_install_message = <<-EOF
# This project have man pages. Install gem-man and follow common instructions on google to be able to access that man pages through man(1)
# EOF
end
