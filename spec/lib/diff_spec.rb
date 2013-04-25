require 'spec_helper'

require File.join(PATH, 'lib', 'diff')


describe '#diff' do
  subject { diff(original, new) }
    
  context '差分が存在しない場合' do
    let(:original) { File.join(FIXTURES, 'diff', 'data1') }
    let(:new) { File.join(FIXTURES, 'diff', 'data2') }

    it { should be_nil }
  end

  context '差分が存在する場合' do
    let(:original) { File.join(FIXTURES, 'diff', 'data1') }
    let(:new) { File.join(FIXTURES, 'diff', 'data3') }

    it { should == EXPECT }
  end
end


EXPECT = <<-EOF
@@ -1,2 +1,4 @@
+j k l
+g h i
 d e f
 a b c
EOF
