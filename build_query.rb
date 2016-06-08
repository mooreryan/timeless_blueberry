#!/usr/bin/env ruby
Signal.trap("PIPE", "EXIT")

ids = []

File.open(ARGV.first).each_line do |line|
  ids << line.chomp
end

puts "select ncbi_taxon from uniref50_to_taxonomy where uniref50 in ("

ids.each_with_index do |id, idx|
  if idx.zero?
    puts "'#{id}'"
  else
    puts ",'#{id}'"
  end
end

puts ");"
