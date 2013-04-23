require 'bundler'
Bundler.setup
Bundler.require

require 'spec_helper'

require File.join(PATH, 'lib', 'DocomoParser')


describe DocomoParser do
  describe '#parse' do
    before do
	    @exists_table1 = 'http://example.com/table1'
      stub_request(:get, @exists_table1).to_return({
        :body => open(File.join(PATH, 'spec', 'fixtures', 'exists_table1.html')),
        :status => 200})

	    @exists_table2 = 'http://example.com/table2'
      stub_request(:get, @exists_table2).to_return({
        :body => open(File.join(PATH, 'spec', 'fixtures', 'exists_table2.html')),
        :status => 200})

	    @exists_table3 = 'http://example.com/table3'
      stub_request(:get, @exists_table3).to_return({
        :body => open(File.join(PATH, 'spec', 'fixtures', 'exists_table3.html')),
        :status => 200})

	    @not_exists_table = 'http://example.com/'
      stub_request(:get, @not_exists_table).to_return({
        :body => open(File.join(PATH, 'spec', 'fixtures', 'not_exists_table.html')),
        :status => 200})
    end


    subject { DocomoParser.new(uri).parse }

    context '<table>が存在するURIを読み込んだ場合' do
	    context '[a, b, c][d, e, f] の場合' do
	      let(:uri) { @exists_table1 }
        it { should == ['a b c', 'd e f'] }
      end

  	  context '[a, b], [d, e] の場合' do
  	    let(:uri) { @exists_table2 }
        it { should == ['a b'] }
      end

      context '<td>内に<a>が入れ子になっている場合' do
        let(:uri) { @exists_table3 }
        it { should == ['a'] }
      end
    end

    context '<table>が存在しないURIを入力した場合' do
      let(:uri) { @not_exists_table }
      it { should == [] }
    end
  end
end

