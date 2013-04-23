require 'bundler'
Bundler.setup
Bundler.require

require 'open-uri'


class DocomoParser
  def initialize(uri)
    @context = Nokogiri::HTML(open uri)
  end

  def parse
    tables = @context.xpath('//table')
    rows = Array.new

    unless tables.empty?
      tables.first.xpath('tr').each do |tr|
        data = String.new
        tr.children.each do |td|
          data << td.text + ' ' if td.is_a?(Nokogiri::XML::Element)
        end
        rows << data.chop
      end
    end

    rows
  end
end
