require 'spec_helper'

require File.join(PATH, 'lib', 'DocomoParser')


describe DocomoParser do
  before do
    @table1 = 'http://example.com/table1'
    stub_request(:get, @table1).to_return({
      :body => open(File.join(FIXTURES, 'DocomoParser', 'table1.html')),
      :status => 200})

    @table2 = 'http://example.com/table2'
    stub_request(:get, @table2).to_return({
      :body => open(File.join(FIXTURES, 'DocomoParser', 'table2.html')),
      :status => 200})

    @table3 = 'http://example.com/table3'
    stub_request(:get, @table3).to_return({
      :body => open(File.join(FIXTURES, 'DocomoParser', 'table3.html')),
      :status => 200})

    @not_exists_table = 'http://example.com/'
    stub_request(:get, @not_exists_table).to_return({
      :body => open(File.join(FIXTURES, 'DocomoParser', 'not_exists_table.html')),
      :status => 200})
  end


  describe '#parse' do
    subject { DocomoParser.new(uri).parse }

    context '<table>が存在するURIを入力したとき' do
      context '[a, b, c][d, e, f][g, h, i] の場合' do
        let(:uri) { @table1 }
        it { should == ['d e f', 'g h i'] }
      end

  	  context '[a, b][c, d], [e, f][g, h] の場合' do
				let(:uri) { @table2 }
        it { should == ['c d'] }
      end

      context '<td>内に<a>が入れ子になっている場合' do
        let(:uri) { @table3 }
        it { should == ['b'] }
      end
    end

    context '<table>が存在しないURIを入力したとき' do
      let(:uri) { @not_exists_table }
      it { should == [] }
    end
  end


  describe '#save' do
    before :all do
      @save_path = File.join(PATH, 'tmp', 'data')
    end

    describe '正常系' do
      before do
        @parser = DocomoParser.new(uri)
        @parser.parse
        @parser.save(@save_path)
      end

      after do
        File.delete(@save_path)
      end

      context '["d e f", "g h i"] を保存する場合' do
        let(:uri) { @table1 }
        it { FileUtils.cmp(@save_path, File.join(FIXTURES, 'DocomoParser', 'table1_parsed')).should be_true }
      end

      context '["c d"] を保存する場合' do
        let(:uri) { @table2 }
        it { FileUtils.cmp(@save_path, File.join(FIXTURES, 'DocomoParser', 'table2_parsed')).should be_true }
      end
    end

    describe '異常系' do
      before do
        @parser = DocomoParser.new(uri)
      end

      context '#parseを呼ぶ前に#saveを実行した場合' do
        let(:uri) { @table1 }
        it { proc{ @parser.save(@save_path) }.should raise_error }
      end

      context '<table>が存在しないURIを入力した場合' do
        let(:uri) { @not_exists_table }
        it { proc{ @parser.parse; @parser.save(@save_path) }.should raise_error }
      end
    end
  end
end

