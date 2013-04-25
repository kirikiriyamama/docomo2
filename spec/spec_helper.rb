require 'bundler'
Bundler.require :default, :test

PATH = __dir__.sub(/\/\w+$/, '')
FIXTURES = File.join(PATH, 'spec', 'fixtures')

ENVIRONMENT = 'test'

require File.join(PATH, 'lib', 'Hash')
