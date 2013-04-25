require 'open-uri'


class DocomoParser
  def initialize(uri)
    @context = Nokogiri::HTML(open(uri))
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

			rows.shift
    end

    @data = rows
  end

  def save(path)
    raise if @data.blank?

    content = String.new
    @data.each do |row|
      content << row + "\n"
    end

    open(path, 'w') do |f|
      f.write(content)
    end
  end
end
