require 'bundler'
Bundler.setup
Bundler.require

PATH = __dir__.sub(/\/\w+$/, '')
FIXTURES = File.join(PATH, 'spec', 'fixtures')
