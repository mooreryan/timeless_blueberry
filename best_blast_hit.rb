#!/usr/bin/env ruby
Signal.trap("PIPE", "EXIT")

blast = {}

ARGV.each do |fname|
  File.open(fname).each_line do |line|
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
