CREATE TABLE nodes(
  ID INT PRIMARY KEY NOT NULL,
  tax_id TEXT,
  parent_tax_id TEXT,
  rank TEXT
);

CREATE TABLE tax_name(
  ID INT PRIMARY KEY NOT NULL,
  tax_id TEXT,
  tax_name TEXT,
  tax_name_unique TEXT
);

CREATE TABLE uniref50_to_taxonomy(
  ID INT PRIMARY KEY NOT NULL,
  uniref50 TEXT,
  ncbi_taxon TEXT
);

CREATE TABLE id_mapping(
  ID INT PRIMARY KEY NOT NULL,
  uniprotkb_ac TEXT,
  uniprotkb_id TEXT,
  geneid TEXT,
  refseq TEXT,
  gi TEXT,
  pdb TEXT,
  go_id TEXT,
  uniref100 TEXT,
  uniref90 TEXT,
  uniref50 TEXT,
  uniparc TEXT,
  pir TEXT,
  ncbi_taxon TEXT,
  mim TEXT,
  unigene TEXT,
  pubmed TEXT,
  embl TEXT,
  embl_cds TEXT,
  ensembl TEXT,
  ensembl_trs TEXT,
  ensembl_pro TEXT,
  additional_pubmed TEXT
);
