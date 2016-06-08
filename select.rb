require "set"

ids_f = ARGV[0]
names_f = ARGV[1]

ids = Set.new

File.open(ids_f).each_line do |line|
  ids << line.chomp
end

File.open(names_f).each_line do |line|
  id, taxid, taxname, _ = line.chomp.split "\t"

  puts [taxid, taxname].join("\t") if ids.include(taxid)
end
