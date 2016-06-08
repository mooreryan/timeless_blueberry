require "abort_if"
include AbortIf

tax_levels = ["superkingdom",
              "phylum",
              "class",
              "order",
              "family",
              "genus",
              "species",
             ]

GUARD = 100

abort_unless ARGV.count == 1,
             "USAGE: tax.rb uniref50_ids.txt"

# all these files were downloaded on 2016-06-05
nodes_f = "assets/nodes.dmp"
names_f = "assets/names.dmp"

names = {}
n=0
File.open(names_f, "rt").each_line do |line|
  n+=1;STDERR.printf("Reading names: %d\r",n) if (n%10_000).zero?
  taxid, name, uniq_name, type = line.chomp.split("\t|\t")

  if type.match "scientific name"
    names[taxid] = name
  end
end
STDERR.puts "\n"

tax_graph = {}
ranks = {}
n = 0
File.open(nodes_f, "rt").each_line do |line|
  n+=1;STDERR.printf("Reading nodes: %d\r",n) if (n%10_000).zero?
  ary = line.chomp.split("\t|\t")
  taxid = ary[0]
  parent_taxid = ary[1]
  rank = ary[2]

  abort_if tax_graph.has_key?(taxid), "#{taxid} is repeated"

  tax_graph[taxid] = parent_taxid
  ranks[taxid] = rank
end
STDERR.puts "\n"

taxids_f = ARGV[0]

user_taxids = []
n = 0
File.open(taxids_f).each_line do |line|
  n+=1;STDERR.printf("Reading taxids: %d\r",n) if (n%10_000).zero?
  id, uid, tid = line.chomp.split("|")
  user_taxids << tid
end
STDERR.puts "\n"

user_taxids.uniq!

STDERR.puts "Unique user_taxids: #{user_taxids.count}"

# from taxids get the tax string
iters = 0
n = 0
puts ["taxid", tax_levels].flatten.join "\t"
user_taxids.each do |taxid|
  iters = 0
  n+=1;STDERR.printf("Making tax strings: %d\r",n) if (n%100).zero?
  rest_ranks = []
  rest_names = []
  # abort_unless ranks[taxid], "#{taxid} not in ranks hash" # actually, uniprot still has some old ncbi taxonomy ids in their ftp so if a taxid isn't in the ranks hash, it could mean that it is an old id
  unless ranks[taxid]
    warn "#{taxid} was not in the #{nodes_f} file"
  end
  unless names[taxid]
    warn "#{taxid} was not in the #{names_f} file"
  end
#  abort_unless names[taxid], "#{taxid} not in names hash"

  the_taxid = taxid
  first_rank = ranks[taxid]
  first_name = names[taxid]
  while (parentid = tax_graph[the_taxid])
    iters += 1
    rest_ranks << ranks[parentid]
    rest_names << names[parentid]
    the_taxid = parentid

    if the_taxid == 1 || the_taxid == "1" # the parent of the root is the root itself
      break
    end

    if iters > GUARD
      abort "Infinte loop? Check #{taxid}, #{parentid}, #{first_rank}, #{first_name}, #{rest_ranks.inspect}, #{rest_names.inspect}"
    end
  end

  all_ranks = [first_rank, rest_ranks].flatten
  all_names = [first_name, rest_names].flatten

  the_hash = Hash[*all_ranks.zip(all_names).flatten]
  the_hash.default = "NA"

  tax_ary = tax_levels.map do |level|
    the_hash[level]
  end

  puts [taxid, tax_ary].flatten.join "\t"
end
STDERR.puts "\n"
