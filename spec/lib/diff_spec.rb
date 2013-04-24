require 'spec_helper'

require File.join(PATH, 'lib', 'diff')


describe '#diff' do
	context '差分が存在しない場合' do
		it { diff(File.join(FIXTURES, 'diff', 'data1'), File.join(FIXTURES, 'diff', 'data2')).should be_nil }
	end

	context '差分が存在する場合' do
		it { diff(File.join(FIXTURES, 'diff', 'data1'), File.join(FIXTURES, 'diff', 'data3')).sub(/(.|\n)*(?=^@)/, '').should == EXPECT }
	end
end


EXPECT = <<-EOF
@@ -1,2 +1,4 @@
+j k l
+g h i
 d e f
 a b c
EOF
