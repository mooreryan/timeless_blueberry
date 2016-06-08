#!/usr/bin/env ruby
Signal.trap("PIPE", "EXIT")

blast = {}

n = 0
ARGV.each do |fname|
  File.open(fname).each_line do |line|
    n+=1;STDERR.printf("Reading -- %d\r", n) if (n % 10_000).zero?
    ary = line.chomp.split "\t"
    query = ary[0]
    evalue = ary[10].to_f

    if blast.has_key?(query) && blast[query][:evalue] > evalue
      blast[query] = { line: line.chomp, evalue: evalue }
    elsif !blast.has_key?(query)
      blast[query] = { line: line.chomp, evalue: evalue }
    end
  end
end

blast.each do |query, info|
  puts info[:line]
end
