require 'bundler'
Bundler.setup
Bundler.require

require File.join(__dir__, 'lib', 'DocomoParser')
require File.join(__dir__, 'lib', 'diff')
require File.join(__dir__, 'lib', 'send_mail')
require File.join(__dir__, 'lib', 'Hash')

ENVIRONMENT = 'production'

DATA_PATH = File.join(__dir__, 'data')
TEMP_DATA_PATH = File.join(__dir__, 'tmp', 'data')

URL = 'http://www.nttdocomo.co.jp/support/utilization/product_update/list/index.html?s=date'


parser = DocomoParser.new(URL)
parser.parse
parser.save(TEMP_DATA_PATH)

unless File.exists?(DATA_PATH)
  FileUtils.mv(TEMP_DATA_PATH, DATA_PATH)
  exit
end

subject = 'Docomo product update information updated'
body = diff(DATA_PATH, TEMP_DATA_PATH)
if body.nil?
  FileUtils.rm(TEMP_DATA_PATH)
  exit
end

FileUtils.mv(TEMP_DATA_PATH, DATA_PATH)
send_mail(File.join(__dir__, 'config', 'email_delivery.yml'), subject, body)
