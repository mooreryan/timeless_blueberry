ARGV.each do |fname|
  File.open("#{fname}.normalized_counts", "w") do |f|
    tax_counts = {}
    total = 0
    File.open(fname).each_line do |line|
      count, tax = line.chomp.split

      total += count.to_i
      tax_counts[tax] = count.to_i
    end

    tax_counts.each do |tax, count|
      f.puts [(count / total.to_f).round(3), count, tax].join "\t"
    end
  end
end
