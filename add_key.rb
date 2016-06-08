#!/usr/bin/env ruby
Signal.trap("PIPE", "EXIT")

n = 0
File.open(ARGV.first).each_line do |line|
  puts "#{n}\t#{line}"
  n += 1
end
