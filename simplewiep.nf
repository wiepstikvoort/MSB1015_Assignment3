#!/usr/bin/env nextflow

Channel
    .fromPath("./short.tsv")
    .splitCsv(header: ['wikidata', 'smiles'], sep:'\t')
    .map{ row -> tuple(row.wikidata, row.smiles) }
    .buffer (size:2, remainder:true)
    .set { molecules_ch }

process printSMILES {
    input:
    each set from molecules_ch

    exec:
       for(entry in set) {
	  wikidata = entry[0]
          smiles = entry[1]
	  if (smiles!= null) {
          println ("$wikidata and $smiles")
       } else {
	  println ("$wikidata has no SMILES")
       }
   }
}


