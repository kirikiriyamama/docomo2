def diff(file1, file2)
	diff = systemu("diff -u #{file1} #{file2}")[1].sub(/(.|\n)*(?=^@)/, '')
	return nil if diff.empty?
	diff.sub(/(.|\n)*(?=^@)/, '')
end
