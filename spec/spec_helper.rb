require 'simplecov'
require 'oj'

$LOAD_PATH.push File.expand_path('../lib', __FILE__)

SimpleCov.start do
  add_filter '/spec/'
end if ENV['COVERAGE']

require 'noorm'
