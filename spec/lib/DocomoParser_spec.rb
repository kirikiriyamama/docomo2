require 'spec_helper'

require File.join(PATH, 'lib', 'DocomoParser')


describe DocomoParser do
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


  describe '#parse' do
    subject { DocomoParser.new(uri).parse }

    context '入力したURIに<table>が存在する場合' do
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

    context '入力したURIに<table>が存在しない場合' do
      let(:uri) { @not_exists_table }
      it { should == [] }
    end
  end


  describe '#save' do
    before(:all) do
      @save_path = File.join(PATH, 'data')
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

      context '["a b c", "d e f"] を保存する場合' do
        let(:uri) { @exists_table1 }
        it { (open(@save_path).readlines - open(File.join(PATH, 'spec', 'fixtures', 'exists_table1_parsed')).readlines).should be_empty }
      end

      context '["a b"] を保存する場合' do
        let(:uri) { @exists_table2 }
        it { (open(@save_path).readlines - open(File.join(PATH, 'spec', 'fixtures', 'exists_table2_parsed')).readlines).should be_empty }
      end
    end

    describe '異常系' do
      before do
        @parser = DocomoParser.new(uri)
      end

      context '#parseを呼ぶ前に#saveを実行した場合' do
        let(:uri) { @exists_table1 }
        it { proc{ @parser.save(@save_path) }.should raise_error }
      end

      context '<table>が存在しないURIを入力した場合' do
        let(:uri) { @not_exists_table }
        it { proc{ @parser.parse; @parser.save(@save_path) }.should raise_error }
      end
    end
  end
end

