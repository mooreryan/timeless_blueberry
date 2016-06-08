require "abort_if"
include AbortIf

abort_unless ARGV.count == 1,
             "USAGE: tax.rb uniref50_ids.txt"

# all these files were downloaded on 2016-06-05
nodes_f = "assets/nodes.dmp"
names_f = "assets/names.dmp"

names = {}
File.open(names_f, "rt").each_line do |line|
  taxid, name, uniq_name, type = line.chomp.split("\t|\t")

  if type.match "scientific name"
    names[taxid] = name
  end
end

tax_graph = {}
ranks = {}
File.open(nodes_f, "rt").each_line do |line|
  ary = line.chomp.split("\t|\t")
  taxid = ary[0]
  parent_taxid = ary[1]
  rank = ary[2]

  abort_if tax_graph.has_key?(taxid), "#{taxid} is repeated"

  tax_graph[taxid] = parent_taxid
  ranks[taxid] = rank
end

taxids_f = ARGV[0]

user_taxids = []
File.open(taxids_f).each_line do |line|
  id, uid, tid = line.chomp.split("|")
  user_taxids << tid
end

user_taxids.uniq!

# from taxids get the tax string
user_taxids.each do |taxid|
  rest_ranks = []
  rest_names = []
  abort_unless ranks[taxid], "#{taxid} not in ranks hash"
  abort_unless names[taxid], "#{taxid} not in names hash"

  first_rank = ranks[taxid]
  first_name = names[taxid]
  while (parentid = tax_graph[taxid])
    rest_ranks << ranks[parentid]
    rest_names << names[parentid]
  end

  all_ranks = [first_rank, rest_ranks].flatten
  all_names = [first_name, rest_names].flatten

  puts [taxid, all_ranks.zip(all_names)].flatten.join "\t"
end
