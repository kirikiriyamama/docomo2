require 'spec_helper'

require File.join(PATH, 'lib', 'diff')


describe '#diff' do
	context '差分が存在しない場合' do
		it { diff(File.join(FIXTURES, 'diff', 'data1'), File.join(FIXTURES, 'diff', 'data2')).should be_nil }
	end

	context '差分が存在する場合' do
		f = Tempfile.open('diff', PATH)
		f.write(diff(File.join(FIXTURES, 'diff', 'data1'), File.join(FIXTURES, 'diff', 'data3')).sub(/(.|\n)*(?=^@)/, ''))

		it { FileUtils.cmp(f.path, File.join(FIXTURES, 'diff', 'diff_data1_data3')).should be_true }

		f.close
	end
end
