require "abort_if"

abort_unless ARGV.count == 1,
             "USAGE: tax.rb uniref50_ids.txt"

nodes = "nodes.dmp"

tax_graph = {}
ranks = {}
File.open(nodes, "rt").each_line do |line|
  ary = line.chomp.split("\t|\t")
  taxid = ary[0]
  parent_taxid = ary[1]
  rank = ary[2]

  abort_if tax_graph.has_key?(taxid), "#{taxid} is repeated"

  tax_graph[taxid] = parent_taxid
  ranks[taxid] = rank
end
