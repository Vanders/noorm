# encoding: utf-8

Gem::Specification.new do |g|
  g.name                    = 'noorm'
  g.version                 = IO.read(File.join(File.dirname(__FILE__), "VERSION")) rescue "0.0.1"
  g.summary                 = "Not an ORM"
  g.description             = "A very simple ORM-like model"
  g.authors                 = ["Kristian Van Der Vliet"]
  g.email                   = 'vanders@liqwyd.com'
  g.homepage                = 'https://github.com/Vanders/noorm'
  g.license                 = 'Apache-2.0'

  g.files                   = `git ls-files`.split($\)
  g.executables             = g.files.grep(%r{^bin/}).map{ |f| File.basename(f) }

  g.add_runtime_dependency 'oj',      '~> 2.0'
  g.add_runtime_dependency 'sequel',  '~> 4.0'
  g.add_runtime_dependency 'sqlite3', '~> 1.3'
end
