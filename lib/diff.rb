def diff(file1, file2)
  diff = systemu("diff -u #{file1} #{file2}")[1]
  return nil if diff.empty?
  diff.sub(/\A(.*\n){2}/, '')
end
