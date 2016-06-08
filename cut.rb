#!/usr/bin/env ruby
Signal.trap("PIPE", "EXIT")

require "trollop"

opts = Trollop.options do
  banner <<-EOS

  Info
    Use it kinda like cut.

  Options:
  EOS

  opt(:field, "Fields to print", type: :ints)
  opt(:delim, "Delimiter to split on", type: :string)
  opt(:out_delim,
      "Output delimiter",
      type: :string,
      default: "\t")
end

opts[:field] = opts[:field].map { |n| n - 1 }

ARGV.each do |fname|
  File.open(fname).each_line do |line|
    ary = line.chomp.split opts[:delim]

    puts opts[:field].map { |col| ary[col] }.join(opts[:out_delim])
  end
end
