#!/usr/bin/env ruby
Signal.trap("PIPE", "EXIT")

tax2_f = ARGV[0]
counts_f = ARGV[1]

File.open(tax2_f).each_line do |line|

end
